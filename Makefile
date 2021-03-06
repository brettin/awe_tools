TOP_DIR = ../..
DEPLOY_RUNTIME ?= /kb/runtime
TARGET ?= /kb/deployment

include $(TOP_DIR)/tools/Makefile.common

# These can be defined here and/or in the auto-deploy config file.
AWE_URL =
SHOCK_URL =

TPAGE_ARGS = \
	--define kb_top=$(TARGET) \
	--define kb_runtime=$(DEPLOY_RUNTIME) \
	--define awe_url=$(AWE_URL) \
	--define shock_url=$(SHOCK_URL)

default: build-utils $(BIN_PERL)  $(BIN_SH)

test:
	@echo "running client and script tests"

deploy: deploy-client

deploy-client: deploy-scripts

deploy-service:
	echo "deploy-service not implemented"

deploy-scripts: build-utils deploy-perl-scripts deploy-sh-scripts 


build-utils:
	$(TPAGE) $(TPAGE_ARGS) templates/delete.tt > scripts/awe-delete.pl
	$(TPAGE) $(TPAGE_ARGS) templates/clients.tt > scripts/awe-clients.pl
	$(TPAGE) $(TPAGE_ARGS) templates/jobs.tt > scripts/awe-jobs.pl
	$(TPAGE) $(TPAGE_ARGS) templates/job.tt > scripts/awe-job.pl
	$(TPAGE) $(TPAGE_ARGS) templates/data_urls.tt > scripts/awe-data_urls.pl
	$(TPAGE) $(TPAGE_ARGS) templates/job_state.tt > scripts/awe-job_state.pl
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
