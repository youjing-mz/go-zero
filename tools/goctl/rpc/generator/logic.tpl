package {{.packageName}}

import (
	"context"

	{{.imports}}

	"github.com/zeromicro/go-zero/core/logx"
)

type {{.logicName}} struct {
	ctx    context.Context
	svcCtx *svc.ServiceContext
	logx.Logger
	rpcLog.RpcLogger
}

func New{{.logicName}}(ctx context.Context,svcCtx *svc.ServiceContext, rpcLog rpcLog.RpcLogger) *{{.logicName}} {
	return &{{.logicName}}{
		ctx:    ctx,
		svcCtx: svcCtx,
		Logger: logx.WithContext(ctx),
		RpcLogger: rpcLog,
	}
}
{{.functions}}
