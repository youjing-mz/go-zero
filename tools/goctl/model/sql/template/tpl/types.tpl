type (
	{{.lowerStartCamelObject}}Model interface{
		{{.method}}
		Trans(ctx context.Context, fn func(context context.Context, session sqlx.Session) error) error
		WithSession(session sqlx.Session) *default{{.upperStartCamelObject}}Model
	}

	default{{.upperStartCamelObject}}Model struct {
		{{if .withCache}}sqlc.CachedConn{{else}}conn sqlx.SqlConn{{end}}
		table string
	}

	{{.upperStartCamelObject}} struct {
		{{.fields}}
	}
)
