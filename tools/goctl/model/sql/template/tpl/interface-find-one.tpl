FindOne(ctx context.Context, {{.lowerStartCamelPrimaryKey}} {{.dataType}}) (*{{.upperStartCamelObject}}, error)
FindAll(ctx context.Context) ([]{{.upperStartCamelObject}}, error)