Insert(ctx context.Context, data *{{.upperStartCamelObject}}) error
InsertOne(ctx context.Context, data *{{.upperStartCamelObject}}) (sql.Result, error)
InsertBatch(ctx context.Context, data []{{.upperStartCamelObject}}) error