func (m *default{{.upperStartCamelObject}}Model) Update(ctx context.Context, data *{{.upperStartCamelObject}}) error {
	{{if .withCache}}{{.keys}}
    ret, err:= m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
		{{if .hasRev}}query := fmt.Sprintf("update %s set %s where {{.originalPrimaryKey}} = {{if .postgreSql}}$1{{else}}?{{end}} and `rev` = ?", m.table, {{.lowerStartCamelObject}}RowsWithPlaceHolder)
			return conn.ExecCtx(ctx, query, {{.expressionValues}}, data.Rev)
		{{else}}query := fmt.Sprintf("update %s set %s where {{.originalPrimaryKey}} = {{if .postgreSql}}$1{{else}}?{{end}}", m.table, {{.lowerStartCamelObject}}RowsWithPlaceHolder)
		return conn.ExecCtx(ctx, query, {{.expressionValues}}){{end}}
	}, {{.keyValues}}){{else}}query := fmt.Sprintf("update %s set %s where {{.originalPrimaryKey}} = {{if .postgreSql}}$1{{else}}?{{end}}", m.table, {{.lowerStartCamelObject}}RowsWithPlaceHolder)
    ret,err := m.conn.ExecCtx(ctx, query, {{.expressionValues}}){{end}}
	if err != nil {
		return err
	}
	affected, err := ret.RowsAffected()
	if err != nil {
		return err
	}
	if affected != 1 {
		return ErrNoRowAffected
	}
	{{if .withCache}}
	var allKeys []string
    allKeys = append(allKeys, {{.keyValues}})
	DelayDelKey(allKeys, m.CachedConn)
    {{end}}
	return nil
}
