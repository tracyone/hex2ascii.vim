# --------通用makefile for gcc/g++/gnu cross compiler--------------------
# file		Makefile
# project	hex2ascii
# date		2016-03-26/19:49:58
# author	tracyone , tracyone@live.cn
# history
# 
# Recommand makefile rule:(和shell script统一)
# 变量:变量名和等号之间不要加空格,用花括号引用变量
# 函数:用圆括号调用函数

# operating system name
OS_NAME:=$(shell uname -s)

# tools
AR:=ar
SED:=sed
AWK:=awk
CP:=cp -a
RM:=rm -rf
ECHO:=echo

# 交叉编译器前缀...比如说arm-linux-
CROSS_COMPILE:=

# c compiler
CC:=${CROSS_COMPILE}gcc
# 编译的选项
CFLAGS:=-c -Wall 
# 链接的选项。-l需要链接的库,-staic等
CLDFLAGS:=

# cpp compiler
CXX:=${CROSS_COMPILE}g++
# 编译的选项
CXXFLAGS:=-c -Wall 
# 链接的选项。-l需要链接的库,-staic等
CXXLDFLAGS:=

# 编译时指定的宏定义:-D选项
DFLAGS:=

# 库和头文件的搜索路径:-I选项和-L
INCULDES:=
LIBDIRS:=

# 指定忽略的文件夹,请以|符号分离每个目录
IGNORE_DIR:=Debug|Release
IGNORE_DIR+=

# 指定源代码路径，以空格分开..
SRC_DIR:=. $(shell find . ! -path "." -type d | grep -Ev '${IGNORE_DIR}')

# 指定支持的源代码扩展名
SFIX:=.c .cc .C .cpp

# 程序要安装的路径
prefix:=.

# 指定依赖文件的搜索路径
vpath %.cpp ${SRC_DIR}
vpath %.c ${SRC_DIR}
vpath %.C ${SRC_DIR}
vpath %.h ${SRC_DIR}

# 定义安装目录
BIN_DIR=$(shell pwd)/Debug
# 存放object的文件夹..
OBJDIR=${BIN_DIR}/objs
DEPENDDIR=${BIN_DIR}/dep

# 得到源文件的集合
SOURCES:=$(foreach x,${SRC_DIR},\
			   $(wildcard $(addprefix ${x}/*,${SFIX})))

# 去掉路径信息和后缀,再追加.o的扩展名,得到目标文件集合(不带路径)，需要去掉路径信息
# 否则连接时可能找不到.o文件
OBJS=$(addprefix ${OBJDIR}/,$(addsuffix .o,$(basename $(notdir ${SOURCES}))))

# 得到依赖文件名集合(带路径)
DEPENDS=$(addprefix ${DEPENDDIR}/,$(addsuffix .d,$(basename $(notdir ${SOURCES}))))

# 程序名字
PROGRAM:=hex2ascii

# 调试标志，如果为1那么相关的编译选项将会做相应的改变
# 以用于调试..如果非1那么将会做相关优化..
DEBUG:=1

# 伪目标定义
.PHONY:all clean distclean install print_info test

# 最终目标..
all:print_info ${PROGRAM} install

print_info:
	@${ECHO} "Do some setting......"
	@mkdir -p ${BIN_DIR}
	@mkdir -p ${OBJDIR}
	@mkdir -p ${DEPENDDIR}
ifeq ($(DEBUG),1)
	@${ECHO} "Setting project for debug"
CFLAGS+=-g
CXXFLAGS+=-g
DFLAGS+=-D_TRACYONE_DEBUG
BIN_DIR=./Debug
else
	@${ECHO} "Setting project for release"
CFLAGS+=-O2
CXXFLAGS+=-O2
BIN_DIR=./Release
endif


${PROGRAM}:${DEPENDS} ${OBJS}
ifeq ($(strip $(filter-out %.c,${SOURCES})),)
	${CC} -o ${BIN_DIR}/$@ ${LIBDIRS}  ${OBJS} ${CLDFLAGS}
else
	${CXX}  -o ${BIN_DIR}/$@ ${LIBDIRS} ${OBJS} ${CXXLDFLAGS}
endif

# rule for .o
${OBJDIR}/%.o:%.c
	${CC} $< -o $@ ${DFLAGS} ${CFLAGS} ${INCULDES} 

${OBJDIR}/%.o:%.cc
	${CXX}  $< -o $@ ${DFLAGS} ${CXXFLAGS} ${INCULDES}

${OBJDIR}/%.o:%.cpp
	${CXX}  $< -o $@ ${DFLAGS} ${CXXFLAGS} ${INCULDES}

${OBJDIR}/%.o:%.C
	${CXX}  $< -o $@ ${DFLAGS} ${CFLAGS} ${INCULDES}

# rule for .d
${DEPENDDIR}/%.d:%.c
	@${CC} -MM -MD ${INCULDES} $< -o $@

${DEPENDDIR}/%.d:%.cc
	@${CXX} -MM -MD ${INCULDES} $< -o $@

${DEPENDDIR}/%.d:%.cpp
	@${CXX} -MM -MD ${INCULDES} $< -o $@

${DEPENDDIR}/%.d:%.C
	@${CC} -MM -MD ${INCULDES} $< -o $@

clean:
	-${RM}  ${BIN_DIR}/${PROGRAM}
	-${RM}  ${OBJDIR}/*.o
	-${RM}  ${DEPENDDIR}/*.d
	-${RM}  ./Debug
	-${RM}  ./Release
	-${RM}  ${PROGRAM}
	-${RM}  ${prefix}/${PROGRAM}

install:
	@${ECHO} Starting install......
	install -v ${BIN_DIR}/${PROGRAM} ${prefix}
test:
	./hex2ascii xx.txt

