func (m *default{{.upperStartCamelObject}}Model) Insert(ctx context.Context, data *{{.upperStartCamelObject}}) error {
	{{if .withCache}}{{.keys}}
    ret, err := m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
		query := fmt.Sprintf("insert into %s (%s) values ({{.expression}})", m.table, {{.lowerStartCamelObject}}RowsExpectAutoSet)
		return conn.ExecCtx(ctx, query, {{.expressionValues}})
	}, {{.keyValues}}){{else}}query := fmt.Sprintf("insert into %s (%s) values ({{.expression}})", m.table, {{.lowerStartCamelObject}}RowsExpectAutoSet)
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
	return nil
}

func (m *default{{.upperStartCamelObject}}Model) generateInsertBatchSQLStatements(count int) string {
    var builder strings.Builder
    sqls := make([]string, count)

    for i := range sqls {
        size := len(strings.Split({{.lowerStartCamelObject}}RowsExpectAutoSet, ","))
		params := make([]string, size)
		for i := 0; i < size; i++ {
			params[i] = "?"
		}
		sqls[i] = "("
		sqls[i] += strings.Join(params, ",")
		sqls[i] += ")"
    }

    builder.WriteString(sqls[0])
    for _, s := range sqls[1:] {
        builder.WriteString(",")
        builder.WriteString(s)
    }

    return builder.String()
}

func (m *default{{.upperStartCamelObject}}Model) InsertBatch(ctx context.Context, dataList []{{.upperStartCamelObject}}) error {
	dataCount := len(dataList)
	if dataCount == 0 {
		return nil
	}
    ret, err := m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
		query := fmt.Sprintf("insert into %s (%s) values %s", m.table, {{.lowerStartCamelObject}}RowsExpectAutoSet, m.generateInsertBatchSQLStatements(dataCount))
		var params []interface{}
		for _, data := range dataList {
			params = append(params, {{.expressionValues}})
		}
		return conn.ExecCtx(ctx, query, params...)
	})
	if err != nil {
		return err
	}
	affected, err := ret.RowsAffected()
	if err != nil {
		return err
	}
	if int(affected) != dataCount {
		return ErrNoRowAffected
	}
	return nil
}
