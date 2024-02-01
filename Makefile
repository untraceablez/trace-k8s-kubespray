.DEFAULT_GOAL := setup-kubespray

# Define python virtual environment location
KUBESPRAYDIR=kubespray
VENV_NAME=kubespray-venv
VENV_DIR=$(HOME)/.python/$(VENV_NAME)

# Define source and destination directories for k8s-clusters managed by kubespray
CLUSTERS_SOURCE_DIR := $(PWD)/clusters
CLUSTERS_DEST_DIR := $(PWD)/kubespray/inventory

# List all subdirectories in the source directory
SUBDIRS := $(wildcard $(CLUSTERS_SOURCE_DIR)/*)

.PHONY: kubespray-venv

kubespray-venv:
	@echo "Creating virtual environment."
	@python3 -m venv $(VENV_DIR)
	@echo "Ensuring environment requirements are installed"
	@$(VENV_DIR)/bin/python -m pip install --upgrade wheel pip
	@$(VENV_DIR)/bin/pip install -U -r $(KUBESPRAYDIR)/requirements.txt
	@echo "Virtual environment '$(VENV_NAME)' created at $(VENV_DIR)."
	@echo "Activate it using 'source $(VENV_DIR)/bin/activate'"

.PHONY: link-clusters

link-clusters: $(SUBDIRS)
	@echo "Adding clusters to kubespray inventory"
	@for dir in $(SUBDIRS); do \
	    cluster_name="$$(basename "$$dir")"; \
	    symlink="$(CLUSTERS_DEST_DIR)/$$cluster_name"; \
	    if [ ! -e "$$symlink" ]; then \
	        ln -s "$$dir" "$$symlink"; \
	        echo "Created symlink for $$cluster_name"; \
	    else \
	        echo "Symlink for $$cluster_name already exists"; \
	    fi \
	done

.PHONY: setup-kubespray

setup-kubespray: kubespray-venv link-clusters
	@echo "Kubespray setup complete."