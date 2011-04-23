
NAME    = insidefunctor
VERSION = 0.1

BUILD_DIR = build
PKG = $(BUILD_DIR)/$(PKG_FILE)
PKG_FILE = $(NAME)_$(VERSION).tar.gz

RSOURCE = $(wildcard R/*.R)
R = R
RCMD = $(R) CMD
ROXYGEN  = $(RCMD) roxygen
RBUILD   = $(RCMD) build
RINSTALL = $(RCMD) INSTALL
RCHECK   = $(RCMD) check
MV = mv
RM = rm
MKDIR = mkdir -p

all: $(PKG)

$(PKG): $(RSOURCE)
	$(ROXYGEN) -d .
	$(RBUILD) .
	$(MKDIR) $(BUILD_DIR)
	$(MV) $(PKG_FILE) $(PKG)

check: $(RSOURCE)
	$(RCHECK) .

install: $(PKG)
	$(RINSTALL) $(PKG)

clean:
	$(RM) -f build/*


