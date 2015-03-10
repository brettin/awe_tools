TOP_DIR = ../..
DEPLOY_RUNTIME ?= /kb/runtime
TARGET ?= /kb/deployment

include $(TOP_DIR)/tools/Makefile.common

# These can be defined here and/or in the auto-deploy config file.
AWE_HOST =
AWE_API_PORT =
SHOCK_HOST =
SHOCK_API_PORT =

TPAGE_ARGS = --define kb_top=$(TARGET) --define kb_runtime=$(DEPLOY_RUNTIME) --define awe_host=$(AWE_HOST) --define awe_api_port=$(AWE_API_PORT) --define shock_host=$(SHOCK_HOST) --define shock_api_port=$(SHOCK_API_PORT)

default:

test:
	@echo "running client and script tests"

deploy: deploy-client

deploy-client: deploy-scripts

deploy-service:
	echo "deploy-service not implemented"

deploy-scripts: deploy-perl-scripts deploy-sh-scripts 

deploy-perl-scripts: deploy-utils
	mkdir -p $(TARGET)/plbin
	export KB_TOP=$(TARGET); \
	export KB_RUNTIME=$(DEPLOY_RUNTIME); \
	export KB_PERL_PATH=$(TARGET)/lib bash ; \
	for src in $(SRC_PERL) ; do \
		basefile=`basename $$src`; \
		base=`basename $$src .pl`; \
		echo install $$src $$base ; \
		cp $$src $(TARGET)/plbin ; \
		$(WRAP_PERL_SCRIPT) "$(TARGET)/plbin/$$basefile" $(TARGET)/bin/$$base ; \
	done

deploy-sh-scripts: deploy-utils
	mkdir -p $(TARGET)/shbin
	export KB_TOP=$(TARGET); \
	export KB_RUNTIME=$(DEPLOY_RUNTIME); \
	for src in $(SRC_SH) ; do \
		basefile=`basename $$src`; \
		base=`basename $$src .sh`; \
		echo install $$src $$base ; \
		cp $$src $(TARGET)/shbin ; \
		$(WRAP_SH_SCRIPT) "$(TARGET)/shbin/$$basefile" $(TARGET)/bin/$$base ; \
	done

deploy-utils:
	$(TPAGE) $(TPAGE_ARGS) templates/delete.tt > scripts/awe-delete.pl
	$(TPAGE) $(TPAGE_ARGS) templates/clients.tt > scripts/awe-clients.pl
	$(TPAGE) $(TPAGE_ARGS) templates/jobs.tt > scripts/awe-jobs.pl
	$(TPAGE) $(TPAGE_ARGS) templates/job.tt > scripts/awe-job.pl
	$(TPAGE) $(TPAGE_ARGS) templates/qstat.tt > scripts/awe-qstat.sh
	#$(TPAGE) $(TPAGE_ARGS) templates/submit.tt > scripts/mg-submit.sh
	$(TPAGE) $(TPAGE_ARGS) templates/client_delete.tt > scripts/awe-client_delete.pl
	$(TPAGE) $(TPAGE_ARGS) templates/suspended_jobs.tt > scripts/awe-suspended_jobs.pl
	$(TPAGE) $(TPAGE_ARGS) templates/resume_job.tt > scripts/awe-resume_job.pl
	$(TPAGE) $(TPAGE_ARGS) templates/resume_client.tt > scripts/awe-resume_client.pl
	$(TPAGE) $(TPAGE_ARGS) templates/active_clients.tt > scripts/awe-active_clients.pl
	$(TPAGE) $(TPAGE_ARGS) templates/active_jobs.tt > scripts/awe-active_jobs.pl
	$(TPAGE) $(TPAGE_ARGS) templates/queued_jobs.tt > scripts/awe-queued_jobs.pl
	chmod a+x scripts/*.sh
	chmod a+x scripts/*.pl

# the Makefile.common.rules contains a set of rules that can be used
# in this setup. Because it is included last, it has the effect of
# shadowing any targets defined above. So lease be aware of the
# set of targets in the common rules file.
include $(TOP_DIR)/tools/Makefile.common.rules
