CC=gcc
RM=rm -f
CFLAGS=-I.
LDFLAGS=
LDLIBS=

SRCS=direnv.c
OBJS=$(subst .c,.o,$(SRCS))

all: direnv

direnv: $(OBJS)
	$(CC) $(LDFLAGS) -o direnv $(OBJS) $(LDLIBS)

depend: .depend

.depend: $(SRCS)
	rm -f .depend
	$(CC) $(CFLAGS) -MM $^>>./.depend;

clean:
	$(RM) $(OBJS)

dist-clean: clean
	$(RM) *~ .depend direnv

include .depend
