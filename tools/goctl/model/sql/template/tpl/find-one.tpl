func (m *default{{.upperStartCamelObject}}Model) FindOne(ctx context.Context, {{.lowerStartCamelPrimaryKey}} {{.dataType}}) (*{{.upperStartCamelObject}}, error) {
	{{if .withCache}}{{.cacheKey}}
	var resp {{.upperStartCamelObject}}
	if err := m.QueryRowCtx(ctx, &resp, {{.cacheKeyVariable}}, func(ctx context.Context, conn sqlx.SqlConn, v any) error {
		query :=  fmt.Sprintf("select %s from %s where {{.originalPrimaryKey}} = {{if .postgreSql}}$1{{else}}?{{end}} limit 1", {{.lowerStartCamelObject}}Rows, m.table)
		return conn.QueryRowCtx(ctx, v, query, {{.lowerStartCamelPrimaryKey}})
	}); err != nil {
		return nil, dbutils.HandleMySQLError(err)
	}
	return &resp, nil
    {{else}}query := fmt.Sprintf("select %s from %s where {{.originalPrimaryKey}} = {{if .postgreSql}}$1{{else}}?{{end}} limit 1", {{.lowerStartCamelObject}}Rows, m.table)
	var resp {{.upperStartCamelObject}}
	if err := m.conn.QueryRowCtx(ctx, &resp, query, {{.lowerStartCamelPrimaryKey}}); err != nil {
        return nil, dbutils.HandleMySQLError(err)
    }
    return &resp, nil
	{{end}}
}

func (m *default{{.upperStartCamelObject}}Model) FindAll(ctx context.Context) ([]{{.upperStartCamelObject}}, error) {
	query := fmt.Sprintf("select %s from %s", {{.lowerStartCamelObject}}Rows, m.table)
	var resp []{{.upperStartCamelObject}}
	if err := m.QueryRowsNoCacheCtx(ctx, &resp, query); err != nil {
        return nil, dbutils.HandleMySQLError(err)
	}
	return resp, nil
}

