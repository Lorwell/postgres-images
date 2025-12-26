-- 启用 zhparser 扩展（中文分词支持）
CREATE EXTENSION zhparser;
CREATE TEXT SEARCH CONFIGURATION zh_cn (PARSER = zhparser);
ALTER TEXT SEARCH CONFIGURATION zh_cn ADD MAPPING FOR n,v,a,i,j,t WITH simple;
