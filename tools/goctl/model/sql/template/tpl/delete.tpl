func (m *default{{.upperStartCamelObject}}Model) Delete(ctx context.Context, {{.lowerStartCamelPrimaryKey}} {{.dataType}}) error {
	{{if .withCache}}{{if .containsIndexCache}}data, err:=m.FindOne(ctx, {{.lowerStartCamelPrimaryKey}})
	if err!=nil{
		return err
	}

{{end}}	{{.keys}}
    _, err {{if .containsIndexCache}}={{else}}:={{end}} m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
		query := fmt.Sprintf("delete from %s where {{.originalPrimaryKey}} = {{if .postgreSql}}$1{{else}}?{{end}}", m.table)
		return conn.ExecCtx(ctx, query, {{.lowerStartCamelPrimaryKey}})
	}, {{.keyValues}}){{else}}query := fmt.Sprintf("delete from %s where {{.originalPrimaryKey}} = {{if .postgreSql}}$1{{else}}?{{end}}", m.table)
		_,err:=m.conn.ExecCtx(ctx, query, {{.lowerStartCamelPrimaryKey}}){{end}}
	return err
}

func (m *default{{.upperStartCamelObject}}Model) DeleteAll(ctx context.Context) error {
	var records []{{.upperStartCamelObject}}
	// Construct the base query for fetching paged records
	query := fmt.Sprintf("SELECT * FROM %s WHERE 1", m.table)
	var queryParams []interface{}
	if err := m.CachedConn.QueryRowsNoCacheCtx(ctx, &records, query, queryParams...); err != nil {
		return  err
	}
	for _, record := range records {
		m.Delete(ctx, record.{{.upperStartCamelPrimaryKey}})
	}
	return nil
}

func (m *default{{.upperStartCamelObject}}Model) generateDeleteBatchSQLStatements(ids []{{.dataType}}) string {
	var builder strings.Builder
    sqls := make([]string, int(len(ids)))

	for i := range ids {
		sqls[i] = "?"
	}

    builder.WriteString(sqls[0])
    for _, s := range sqls[1:] {
        builder.WriteString(",")
        builder.WriteString(s)
    }

    return builder.String()
}

func (m *default{{.upperStartCamelObject}}Model) DeleteBatch(ctx context.Context, ids []{{.dataType}}) error {
	if len(ids) == 0 {
		return nil
	}
	{{if .withCache}} var allKeys []string
	for _, {{.lowerStartCamelPrimaryKey}} := range ids {
		{{if .containsIndexCache}}data, err:=m.FindOne(ctx, {{.lowerStartCamelPrimaryKey}})
		if err!=nil{
			return err
		}{{end}}
		{{.keys}}
		allKeys = append(allKeys, {{.keyValues}})
	}

    var args []interface{}
    for _, id := range ids {
        args = append(args, id)
    }

    _, err := m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
		query := fmt.Sprintf("delete from %s where {{.originalPrimaryKey}} IN (%s)", m.table, m.generateDeleteBatchSQLStatements(ids))
		return conn.ExecCtx(ctx, query, args...)
	}, allKeys...){{else}}query := fmt.Sprintf("delete from %s where {{.originalPrimaryKey}} IN (%s)", m.table, generateDeleteBatchSQLStatements(ids))
		_,err:=m.conn.ExecCtx(ctx, query, args...){{end}}
	return err
}
