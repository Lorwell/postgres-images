# PostgreSQL Docker 镜像库

这是一个包含多种 PostgreSQL 插件组合的 Docker 镜像仓库,为不同场景提供预配置的 PostgreSQL 环境。

## 镜像列表

| 镜像 | 描述 | PostgreSQL 版本 |
|------|------|----------------|
| `zhparser+pgvertor` | 中文全文搜索 + 向量相似度搜索 | 14, 15, 16, 17, 18 |
| `zhparser+pgvertor+age` | 中文全文搜索 + 向量搜索 + 图数据库 | 14, 15, 16, 17 |

---

## zhparser + pgvector

集成中文全文搜索和向量相似度搜索能力的 PostgreSQL 镜像。

### 包含插件

- **zhparser**: 基于 SCWS 的中文分词插件,支持中文全文搜索
- **pgvector**: 向量相似度搜索插件,支持向量存储和相似度查询

### 适用场景

- 中文全文搜索应用
- AI/ML 向量数据库
- RAG (Retrieval-Augmented Generation) 应用
- 语义搜索系统

### 拉取镜像

```bash
# PostgreSQL 18
docker pull moailaozi/postgres-images:zhparser-pgvector-18

# PostgreSQL 17
docker pull moailaozi/postgres-images:zhparser-pgvector-17

# 其他版本: 14, 15, 16
```

### 使用示例

```bash
docker run -d \
  --name postgres-zh-pgvector \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -p 5432:5432 \
  moailaozi/postgres-images:zhparser-pgvector-18
```

### SQL 使用

```sql
-- 启用 pgvector 扩展
CREATE EXTENSION vector;

-- 创建向量表
CREATE TABLE documents (
  id SERIAL PRIMARY KEY,
  content TEXT,
  embedding vector(1536)
);

-- 启用 zhparser 扩展
CREATE EXTENSION zhparser;

-- 创建中文全文搜索配置
CREATE TEXT SEARCH CONFIGURATION zh_cn (PARSER = zhparser);
ALTER TEXT SEARCH CONFIGURATION zh_cn ADD MAPPING FOR n,v,a,i,j,t WITH simple;

-- 创建全文搜索索引
CREATE INDEX ON documents USING gin(to_tsvector('zh_cn', content));
```

---

## zhparser + pgvector + Apache AGE

集成中文全文搜索、向量搜索和图数据库能力的 PostgreSQL 镜像。

### 包含插件

- **zhparser**: 基于 SCWS 的中文分词插件
- **pgvector**: 向量相似度搜索插件
- **Apache AGE**: 图数据库扩展,支持 Cypher 查询语言

### 适用场景

- 知识图谱应用
- 社交网络分析
- 推荐系统
- 复杂关系查询

### 拉取镜像

```bash
# PostgreSQL 17
docker pull moailaozi/postgres-images:zhparser-pgvector-age-17

# 其他版本: 14, 15, 16
```

### 使用示例

```bash
docker run -d \
  --name postgres-graph \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -p 5432:5432 \
  moailaozi/postgres-images:zhparser-pgvector-age-17
```

### SQL 使用

```sql
-- 启用 Apache AGE 扩展
CREATE EXTENSION age;
LOAD 'age';

-- 启用其他扩展
CREATE EXTENSION vector;
CREATE EXTENSION zhparser;

-- 创建图数据库
SELECT create_graph('my_graph');

-- 使用 Cypher 查询
SELECT * FROM cypher('my_graph', $$
  MATCH (u:User)-[:FRIENDS]->(f:User)
  RETURN u.name, f.name
$$) AS (user_name TEXT, friend_name TEXT);
```

---

## 环境变量

| 变量 | 默认值 | 描述 |
|------|--------|------|
| `POSTGRES_DB` | postgres | 初始数据库名称 |
| `POSTGRES_USER` | postgres | 初始用户名 |
| `POSTGRES_PASSWORD` | - | 必需,超级用户密码 |

---

## 本地构建

### zhparser + pgvector

```bash
cd zhparser+pgvertor
docker build -t my-postgres-zh-pgvector --build-arg PG_MAJOR=18 .
```

### zhparser + pgvector + Apache AGE

```bash
cd zhparser+pgvertor+age
docker build -t my-postgres-graph --build-arg PG_MAJOR=17 .
```

---

## 许可证

本项目镜像包含以下开源软件:

- PostgreSQL (PostgreSQL License)
- pgvector (PostgreSQL License)
- zhparser (MIT License)
- SCWS (BSD License)
- Apache AGE (Apache License 2.0)

## 相关链接

- [PostgreSQL 官方文档](https://www.postgresql.org/docs/)
- [pgvector GitHub](https://github.com/pgvector/pgvector)
- [zhparser GitHub](https://github.com/amutu/zhparser)
- [Apache AGE 官网](https://age.apache.org/)
