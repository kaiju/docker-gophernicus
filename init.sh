#!/bin/sh

SERVER_ARGS=""

# Defaults
PORT=${PORT:-70}
LOG_FILE=${LOG_FILE:-/var/log/gophernicus.log}
GOPHER_ROOT=${GOPHER_ROOT:-/var/gopher}

# Arguments
if test ${PORT}
then
	SERVER_ARGS="${SERVER_ARGS} -p ${PORT}"
fi

if test ${TLS_PORT}
then
	SERVER_ARGS="${SERVER_ARGS} -T ${TLS_PORT}"
fi

if test ${GOPHER_ROOT}
then
	SERVER_ARGS="${SERVER_ARGS} -r ${GOPHER_ROOT}"
fi

if test ${DEFAULT_FILE_TYPE}
then
	SERVER_ARGS="${SERVER_ARGS} -t ${DEFAULT_FILE_TYPE}"
fi

if test ${GOPHER_MAPFILE}
then
	SERVER_ARGS="${SERVER_ARGS} -g ${GOPHER_MAPFILE}"
fi

if test ${GOPHER_TAGFILE}
then
	SERVER_ARGS="${SERVER_ARGS} -a ${GOPHER_TAGFILE}"
fi

if test ${CGI_DIR}
then
	SERVER_ARGS="${SERVER_ARGS} -c ${CGI_DIR}"
fi

if test ${USER_DIR}
then
	SERVER_ARGS="${SERVER_ARGS} -u ${USER_DIR}"
fi

if test ${LOG_FILE}
then
	SERVER_ARGS="${SERVER_ARGS} -l ${LOG_FILE}"
	mkdir -p "$(dirname ${LOG_FILE})"
	touch "${LOG_FILE}"
	chown nobody.nobody "${LOG_FILE}"
fi

if test ${DEFAULT_WIDTH}
then
	SERVER_ARGS="${SERVER_ARGS} -w ${DEFAULT_WIDTH}"
fi

if test ${DEFAULT_CHARSET}
then
	SERVER_ARGS="${SERVER_ARGS} -o ${DEFAULT_CHARSET}"
fi

if test ${SESSION_TIMEOUT}
then
	SERVER_ARGS="${SERVER_ARGS} -s ${SESSION_TIMEOUT}"
fi

if test ${MAX_HITS}
then
	SERVER_ARGS="${SERVER_ARGS} -i ${MAX_HITS}"
fi

if test ${MAX_TRANSFER_KB}
then
	SERVER_ARGS="${SERVER_ARGS} -k ${MAX_TRANSFER_KB}"
fi

if test ${FILTER_DIR}
then
	SERVER_ARGS="${SERVER_ARGS} -f ${FILTER_DIR}"
fi

# Booleans
if test ${DISABLE_VHOSTS}
then
	SERVER_ARGS="${SERVER_ARGS} -nv"
fi

if test ${DISABLE_PARENT_DIR_LINKS}
then
	SERVER_ARGS="${SERVER_ARGS} -nl"
fi

if test ${DISABLE_HEADER}
then
	SERVER_ARGS="${SERVER_ARGS} -nh"
fi

if test ${DISABLE_FOOTER}
then
	SERVER_ARGS="${SERVER_ARGS} -nf"
fi

if test ${DISABLE_MENU_METADATA}
then
	SERVER_ARGS="${SERVER_ARGS} -nd"
fi

if test ${DISABLE_CONTENT_DETECTION}
then
	SERVER_ARGS+"${SERVER_ARGS} -nc"
fi

if test ${DISABLE_CHARSET_CONV}
then
	SERVER_ARGS+"${SERVER_ARGS} -no"
fi

if test ${DISABLE_QUERY_STRINGS}
then
	SERVER_ARGS+"${SERVER_ARGS} -nq"
fi

if test ${DISABLE_SYSLOG}
then
	SERVER_ARGS+"${SERVER_ARGS} -ns"
fi

if test ${DISABLE_AUTOGEN_CAPS}
then
	SERVER_ARGS+"${SERVER_ARGS} -na"
fi

if test ${DISABLE_SERVER_STATUS}
then
	SERVER_ARGS+"${SERVER_ARGS} -nt"
fi

if test ${DISABLE_HAPROXY}
then
	SERVER_ARGS+"${SERVER_ARGS} -np"
fi

if test ${DISABLE_EXECUTABLES}
then
	SERVER_ARGS+"${SERVER_ARGS} -nx"
fi

if test ${DISABLE_USERDIRS}
then
	SERVER_ARGS+"${SERVER_ARGS} -nu"
fi

# Write out our gophernicus xinetd configuration with all our server arguments
cat << EOF > /etc/xinetd.d/gophernicus
# default: on
# description: Gophernicus - Modern full-featured gopher server
service gopher
{
	socket_type	= stream
	protocol    = tcp
	port        = ${PORT}
	wait		= no
	user		= nobody
	server		= /usr/sbin/gophernicus
	server_args = ${SERVER_ARGS}
	disable		= no
}
EOF

# Kick off xinetd to start serving gophernicus
/usr/sbin/xinetd

# Give us some logs on stdout
tail -f ${LOG_FILE}
