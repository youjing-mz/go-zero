package {{.pkg}}

import (
	"github.com/zeromicro/go-zero/core/stores/sqlx"
	"github.com/motionz-tech/flowz-srv/common/xerr"
)

var ErrNotFound = sqlx.ErrNotFound
var ErrNoRowAffected = xerr.ErrNoRowAffected

