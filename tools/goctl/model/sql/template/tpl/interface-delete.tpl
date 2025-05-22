Delete(ctx context.Context, {{.lowerStartCamelPrimaryKey}} {{.dataType}}) error
DeleteAll(ctx context.Context) error 
DeleteBatch(ctx context.Context, {{.lowerStartCamelPrimaryKey}}s []{{.dataType}}) error
