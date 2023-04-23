dev: # dev를 바라보는 버전
	TUIST_ENDPOINT=DEV tuist generate
release: # prod
	TUIST_ENDPOINT=RELEASE tuist generate
debug: # FLEX, Inject, Lookin 등이 적용된 버전
	TUIST_ENDPOINT=DEBUG tuist generate
