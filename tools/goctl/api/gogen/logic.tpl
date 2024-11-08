package {{.pkgName}}

import (
	"github.com/jinzhu/copier"
	"github.com/motionz-tech/flowz-srv/common/ctxdata"
	{{.imports}}
	"github.com/pkg/errors"
	"github.com/motionz-tech/flowz-srv/service/{{.serviceName}}/rpc/{{.serviceName}}"
)

type {{.logic}} struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func New{{.logic}}(ctx context.Context, svcCtx *svc.ServiceContext) *{{.logic}} {
	return &{{.logic}}{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *{{.logic}}) {{.function}}({{.request}}) {{.responseType}} {
	userId, err := ctxdata.GetUidFromCtx(l.ctx)
	if err != nil {
		return nil, err
	}

	var rpcReq {{.serviceName}}.{{.typeName}}Req
	err = copier.Copy(&rpcReq, req)
	if err != nil {
		return nil, errors.Wrapf(err, "copier.Copy req failed")
	}

	rpcReq.Uid = userId

	rpcRsp, err := l.svcCtx.{{.upperStartCamelServiceName}}Rpc.{{.typeName}}(l.ctx, &rpcReq)
	if err != nil {
		return nil, errors.Wrapf(err, "rpc failed")
	}

	var rsp types.{{.typeName}}Rsp
	err = copier.CopyWithOption(&rsp, rpcRsp, copier.Option{DeepCopy: true})
	if err != nil {
		return nil, errors.Wrapf(err, "copier.Copy rsp failed")
	}

	{{.returnString}}
}
