# PostgreSQL Docker 镜像库

这是一个包含多种 PostgreSQL 插件组合的 Docker 镜像仓库,为不同场景提供预配置的 PostgreSQL 环境。

## 🚀 可用镜像

### zhparser + pgvector

集成中文全文搜索和向量相似度搜索能力的 PostgreSQL 镜像。

**包含插件:**

- **zhparser**: 基于 SCWS 的中文分词插件,支持中文全文搜索
- **pgvector**: 向量相似度搜索插件,支持向量存储和相似度查询

**适用场景:**

- 中文全文搜索应用
- AI/ML 向量数据库
- RAG (Retrieval-Augmented Generation) 应用
- 语义搜索系统

**支持版本:**

- PostgreSQL 18
- Debian Bookworm