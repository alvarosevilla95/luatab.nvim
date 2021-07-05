.DEFAULT_GOAL = check

lint:
	@luacheck lua/luatab

format:
	@for file in `find . -name '*.lua'`;do lua-format $$file -i; done;

check: lint test
