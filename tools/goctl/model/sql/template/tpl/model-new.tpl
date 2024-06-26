
var {{.upperStartCamelObject}}ModelTableName = {{.table}}
const {{.upperStartCamelObject}}ModelTableStaticName = {{.table}}
func new{{.upperStartCamelObject}}Model(conn sqlx.SqlConn{{if .withCache}}, c cache.CacheConf, opts ...cache.Option{{end}}) *default{{.upperStartCamelObject}}Model {
	return &default{{.upperStartCamelObject}}Model{
		{{if .withCache}}CachedConn: sqlc.NewConn(conn, c, opts...){{else}}conn:conn{{end}},
		table:     {{.upperStartCamelObject}}ModelTableName,
	}
}

func (m *default{{.upperStartCamelObject}}Model) WithSession(session sqlx.Session) *default{{.upperStartCamelObject}}Model {
	return &default{{.upperStartCamelObject}}Model{
		{{if .withCache}}CachedConn:m.CachedConn.WithSession(session){{else}}conn:sqlx.NewSqlConnFromSession(session){{end}},
		table:      {{.upperStartCamelObject}}ModelTableName,
	}
}

func (m *default{{.upperStartCamelObject}}Model) WithEventIdSession(session sqlx.Session, eventId string, specialTableNameMap map[string]string) *default{{.upperStartCamelObject}}Model {
    var tableName, ok = specialTableNameMap[fmt.Sprintf("%s_%s", {{.upperStartCamelObject}}ModelTableStaticName, eventId)]
	if ok {
		return &default{{.upperStartCamelObject}}Model{
        		{{if .withCache}}CachedConn:m.CachedConn.WithSession(session){{else}}conn:sqlx.NewSqlConnFromSession(session){{end}},
        		table:      tableName,
        }
	}
	return &default{{.upperStartCamelObject}}Model{
		{{if .withCache}}CachedConn:m.CachedConn.WithSession(session){{else}}conn:sqlx.NewSqlConnFromSession(session){{end}},
		table:      fmt.Sprintf("%s_%s", strings.ReplaceAll({{.upperStartCamelObject}}ModelTableStaticName, "`", ""), eventId),
	}
}

func (m *default{{.upperStartCamelObject}}Model) Trans(ctx context.Context, fn func(ctx context.Context, session sqlx.Session) error) error {
	return m.TransactCtx(ctx, func(ctx context.Context, session sqlx.Session) error {
		return fn(ctx, session)
	})
}
