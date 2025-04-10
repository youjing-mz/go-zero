package {{.pkg}}

import (
	"fmt"
)

// SQLErrorType defines types of SQL errors
type SQLErrorType struct {
	Code    uint16
	Message string
}

// Error implements the error interface for SQLErrorType
func (s SQLErrorType) Error() string {
	return s.Message
}

// Custom application error codes (starting from high numbers to avoid collision)
const (
	AppErrCodeNotFound    uint16 = 10001
	AppErrCodeNoRowAffect uint16 = 10002
)

// MySQL error codes
const (
	MySQLErrDupEntry         uint16 = 1062
	MySQLErrForeignKeyFailed uint16 = 1452
	MySQLErrDataTooLong      uint16 = 1406
	MySQLErrBadNullError     uint16 = 1048
	MySQLErrInvalidFieldVal  uint16 = 1366
	MySQLErrTableNotExists   uint16 = 1146
	MySQLErrUnknownColumn    uint16 = 1054
	MySQLErrAccessDenied     uint16 = 1045
	MySQLErrLockWaitTimeout  uint16 = 1205
	MySQLErrDeadlock         uint16 = 1213
	MySQLErrConnRefused      uint16 = 2003
)

// SQL Error instances
var (
	// Application errors
	ErrNotFound = SQLErrorType{
		Code:    AppErrCodeNotFound,
		Message: "Record not found",
	}

	ErrNoRowAffected = SQLErrorType{
		Code:    AppErrCodeNoRowAffect,
		Message: "No rows affected",
	}

	// MySQL errors
	ErrDupEntry = SQLErrorType{
		Code:    MySQLErrDupEntry,
		Message: "Duplicate entry",
	}

	ErrForeignKeyFailed = SQLErrorType{
		Code:    MySQLErrForeignKeyFailed,
		Message: "Foreign key constraint fails",
	}

	ErrDataTooLong = SQLErrorType{
		Code:    MySQLErrDataTooLong,
		Message: "Data too long for column",
	}

	ErrBadNullError = SQLErrorType{
		Code:    MySQLErrBadNullError,
		Message: "Column cannot be null",
	}

	ErrInvalidFieldVal = SQLErrorType{
		Code:    MySQLErrInvalidFieldVal,
		Message: "Invalid field value",
	}

	ErrTableNotExists = SQLErrorType{
		Code:    MySQLErrTableNotExists,
		Message: "Table doesn't exist",
	}

	ErrUnknownColumn = SQLErrorType{
		Code:    MySQLErrUnknownColumn,
		Message: "Unknown column",
	}

	ErrAccessDenied = SQLErrorType{
		Code:    MySQLErrAccessDenied,
		Message: "Access denied",
	}

	ErrLockWaitTimeout = SQLErrorType{
		Code:    MySQLErrLockWaitTimeout,
		Message: "Lock wait timeout",
	}

	ErrDeadlock = SQLErrorType{
		Code:    MySQLErrDeadlock,
		Message: "Deadlock detected",
	}

	ErrConnRefused = SQLErrorType{
		Code:    MySQLErrConnRefused,
		Message: "Connection refused",
	}
)

// GetSQLError returns an error object for a given error code
func GetSQLError(code uint16) error {
	switch code {
	case AppErrCodeNotFound:
		return ErrNotFound
	case AppErrCodeNoRowAffect:
		return ErrNoRowAffected
	case MySQLErrDupEntry:
		return ErrDupEntry
	case MySQLErrForeignKeyFailed:
		return ErrForeignKeyFailed
	case MySQLErrDataTooLong:
		return ErrDataTooLong
	case MySQLErrBadNullError:
		return ErrBadNullError
	case MySQLErrInvalidFieldVal:
		return ErrInvalidFieldVal
	case MySQLErrTableNotExists:
		return ErrTableNotExists
	case MySQLErrUnknownColumn:
		return ErrUnknownColumn
	case MySQLErrAccessDenied:
		return ErrAccessDenied
	case MySQLErrLockWaitTimeout:
		return ErrLockWaitTimeout
	case MySQLErrDeadlock:
		return ErrDeadlock
	case MySQLErrConnRefused:
		return ErrConnRefused
	default:
		return fmt.Errorf("unknown SQL error code: %d", code)
	}
}

// GetSQLErrorWithDetail returns a detailed error with the original message
func GetSQLErrorWithDetail(code uint16, detail string) error {
	switch code {
	case AppErrCodeNotFound:
		return SQLErrorType{
			Code:    ErrNotFound.Code,
			Message: fmt.Sprintf("%s: %s", ErrNotFound.Message, detail),
		}
	case AppErrCodeNoRowAffect:
		return SQLErrorType{
			Code:    ErrNoRowAffected.Code,
			Message: fmt.Sprintf("%s: %s", ErrNoRowAffected.Message, detail),
		}
	case MySQLErrDupEntry:
		return SQLErrorType{
			Code:    ErrDupEntry.Code,
			Message: fmt.Sprintf("%s: %s", ErrDupEntry.Message, detail),
		}
	case MySQLErrForeignKeyFailed:
		return SQLErrorType{
			Code:    ErrForeignKeyFailed.Code,
			Message: fmt.Sprintf("%s: %s", ErrForeignKeyFailed.Message, detail),
		}
	case MySQLErrDataTooLong:
		return SQLErrorType{
			Code:    ErrDataTooLong.Code,
			Message: fmt.Sprintf("%s: %s", ErrDataTooLong.Message, detail),
		}
	case MySQLErrBadNullError:
		return SQLErrorType{
			Code:    ErrBadNullError.Code,
			Message: fmt.Sprintf("%s: %s", ErrBadNullError.Message, detail),
		}
	case MySQLErrInvalidFieldVal:
		return SQLErrorType{
			Code:    ErrInvalidFieldVal.Code,
			Message: fmt.Sprintf("%s: %s", ErrInvalidFieldVal.Message, detail),
		}
	case MySQLErrTableNotExists:
		return SQLErrorType{
			Code:    ErrTableNotExists.Code,
			Message: fmt.Sprintf("%s: %s", ErrTableNotExists.Message, detail),
		}
	case MySQLErrUnknownColumn:
		return SQLErrorType{
			Code:    ErrUnknownColumn.Code,
			Message: fmt.Sprintf("%s: %s", ErrUnknownColumn.Message, detail),
		}
	case MySQLErrAccessDenied:
		return SQLErrorType{
			Code:    ErrAccessDenied.Code,
			Message: fmt.Sprintf("%s: %s", ErrAccessDenied.Message, detail),
		}
	case MySQLErrLockWaitTimeout:
		return SQLErrorType{
			Code:    ErrLockWaitTimeout.Code,
			Message: fmt.Sprintf("%s: %s", ErrLockWaitTimeout.Message, detail),
		}
	case MySQLErrDeadlock:
		return SQLErrorType{
			Code:    ErrDeadlock.Code,
			Message: fmt.Sprintf("%s: %s", ErrDeadlock.Message, detail),
		}
	case MySQLErrConnRefused:
		return SQLErrorType{
			Code:    ErrConnRefused.Code,
			Message: fmt.Sprintf("%s: %s", ErrConnRefused.Message, detail),
		}
	default:
		return fmt.Errorf("unknown SQL error code %d: %s", code, detail)
	}
}
