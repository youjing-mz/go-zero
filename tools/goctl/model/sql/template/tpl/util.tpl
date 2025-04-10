package {{.pkg}}

import (
	"database/sql"
	"errors"
	"strings"
	"time"

	"github.com/go-sql-driver/mysql"
	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/core/stores/sqlc"
)

func TransformString(input string) string {
	var result strings.Builder
	parts := strings.Split(input, "_")

	for i, part := range parts {
		if i > 0 {
			if len(part) > 0 {
				firstChar := part[0]
				if firstChar >= 'a' && firstChar <= 'z' {
					firstChar -= 'a' - 'A'
				}
				part = string(firstChar) + part[1:]
			}
		}
		result.WriteString(part)
	}

	return result.String()
}

func DelayDelKey(key []string, conn sqlc.CachedConn) {
	go DelKey(conn, key)
}

func DelKey(conn sqlc.CachedConn, key []string) {
	time.Sleep(3 * time.Second)
	if err := conn.DelCache(key...); err != nil {
		logx.Errorf("delay del keys failed, err: [%v]", err)
	}
}

// mysqlUtils.HandleMySQLError converts MySQL errors to application error types
func mysqlUtils.HandleMySQLError(err error) error {
	if err == nil {
		return nil
	}

	// Check for common SQL errors
	if errors.Is(err, sql.ErrNoRows) {
		return ErrNotFound
	}

	if errors.Is(err, sql.ErrTxDone) {
		return err
	}

	// Try to convert MySQL specific errors
	var mysqlErr *mysql.MySQLError
	if errors.As(err, &mysqlErr) {
		// Get the appropriate error type based on MySQL error code
		return GetSQLErrorWithDetail(mysqlErr.Number, mysqlErr.Message)
	}

	// Handle special application errors
	if errors.Is(err, mysqlUtils.ErrNoRowAffected) {
		return mysqlUtils.ErrNoRowAffected
	}

	// Return the original error if we can't map it
	return err
}
