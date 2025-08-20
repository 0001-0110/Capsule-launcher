archive:
	MOD_NAME=$$(jq -r '.name' info.json) && \
	VERSION=$$(jq -r '.version' info.json) && \
	ZIP_NAME="$$MOD_NAME_$$VERSION.zip" && \
	rm -f "$$ZIP_NAME" && \
	git archive --format=zip --prefix="$$MOD_NAME/" --output="$$ZIP_NAME" main
