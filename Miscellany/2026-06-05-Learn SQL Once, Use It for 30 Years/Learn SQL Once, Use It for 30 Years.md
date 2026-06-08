---
title: "Learn SQL Once, Use It for 30 Years"
source: "https://fagnerbrack.com/learn-sql-once-use-it-for-30-years-9aceb0bdee03"
author:
  - "[[Fayner Brack]]"
published: 2026-05-14
created: 2026-06-05
description: "Learn SQL Once, Use It for 30 Years The Only Programming Language Built on Mathematics, Not Fashion Want to come back later? Save this to readplace.com. Learn SQL Once, Use It for 30 Years | Reader …"
tags:
---
## The Only Programming Language Built on Mathematics, Not Fashion

![](https://miro.medium.com/v2/resize:fit:3584/format:webp/1*wZvys-CBZN963Sq-H7CBcQ.png)

A cross-section of rock strata where the upper layers are cracked and crumbling, each labeled with the names of old web technologies like jQuery, Backbone, Flash, and CoffeeScript. Beneath them sits a single solid slab of bedrock with SQL carved into it alongside the mathematical symbols of relational algebra.

Want to come back later? Save this to [readplace.com](https://readplace.com/view/https%3A%2F%2Ffagnerbrack.com%2Flearn-sql-once-use-it-for-30-years-9aceb0bdee03?utm_source=fagnerbrack.com&utm_content=top-text).

## [Learn SQL Once, Use It for 30 Years | Reader View](https://readplace.com/view/https%3A%2F%2Ffagnerbrack.com%2Flearn-sql-once-use-it-for-30-years-9aceb0bdee03?utm_source=fagnerbrack.com&utm_content=top&source=post_page-----9aceb0bdee03---------------------------------------)

### SQL queries from 1995 run unchanged today because relational algebra never changes. Everything else in software does.

readplace.com

SQL is the only programming language a working developer can learn once and use for 30 years without rewriting their mental model. That claim sounds like nostalgia, but it rests on something more durable.

==Open any SQL textbook from 1995. Find the example query:==

```c
SELECT department, COUNT(*) AS headcount
FROM employees
WHERE hire_date > '1994-01-01'
GROUP BY department
HAVING COUNT(*) > 5
ORDER BY headcount DESC;
```

Paste it into PostgreSQL 18 in 2026. It runs. Same syntax, same result, same mental model. Thirty-one years, zero changes.

Now try this experiment with the JavaScript ecosystem. Take a React component from 2015. `React.createClass`, mixins, `componentWillMount`. It doesn't just look old, it throws `TypeError: React.createClass is not a function` the moment it loads. You rewrite it from scratch to ship it today. Ten years passed, and the framework cycled through three different mental models in that time.

## Get Fayner Brack’s stories in your inbox

Join Medium for free to get updates from this writer.

I have used SQL at five companies across fifteen years. The query patterns I learned at the first one still work at the current one. I cannot say that about any other language in my stack.

> ==**SQL endures because relational algebra is mathematics**==**, and mathematics does not have release cycles.**

Edgar Codd formalised relational algebra in 1970. SQL sits on top of it as a declarative interface. You describe what you want. The database engine decides how to get it. The engine improves every year. Your query stays the same.

==JavaScript== and its ecosystem is an environment where browser wars, framework trends, and open-source maintainer preferences reshaped every few years. It rewards you for keeping up.

SQL rewards you for sitting still.

If you are a junior developer, “learn SQL properly” is the most valuable 40 hours you can spend. Not a tutorial. Not an ORM. Actual SQL: joins, subqueries, window functions, query plans. That investment pays you back at every job, in every stack, for decades. Almost nothing else in software has that half-life.

If you are a senior developer, you already know the cost of this stability. SQL has accumulated 40 of warts it cannot easily shed.

NULL is a three-valued logic trap that breaks the intuition of most new users. `GROUP BY` forces you to repeat column lists for no good reason. Date handling is a vendor-specific mess. Each database has its own dialect, and the "standard" is a 4,000-page document that no single implementation fully follows.

These are the costs of backwards compatibility chosen over elegance. SQL locked itself into that tradeoff decades ago. Your 1995 textbook still works because the language refused to break old queries. That same stubbornness means the warts are here to stay.

Most languages reward you for chasing what comes next.

SQL is the rare one that rewards you for learning what is already there.

[![Fayner Brack](https://miro.medium.com/v2/resize:fill:96:96/1*yCpCLqk5oZkQq_E8ABqjOA.jpeg)](https://fagnerbrack.com/?source=post_page---post_author_info--9aceb0bdee03---------------------------------------)[0 following](https://fagnerbrack.com/following?source=post_page---post_author_info--9aceb0bdee03---------------------------------------)

I believe knowledge should be open and free. Since 2015, sharing challenging stuff AI won't tell you. My reading system: [https://readplace.com?utm\_source=m](https://readplace.com/?utm_source=m)

## Responses (7)

Write a response[What are your thoughts?](https://medium.com/m/signin?operation=register&redirect=https%3A%2F%2Ffagnerbrack.com%2Flearn-sql-once-use-it-for-30-years-9aceb0bdee03&source=---post_responses--9aceb0bdee03---------------------respond_sidebar------------------)

```c
Spot on! I think I first learned of SQL (via reading up on Codd's relational algebra) in the early 1980s, started using SQL (Oracle) in 1984-85. It kept rearing its wart-mottled head, in various incarnations (msql, MySQL, PostgreSQL, etc) throughout my career.
```

7

==SQL endures because relational algebra is mathematics==

```c
LISP endures partly because lambda calculus is its mathematical basis.
```

4

```c
Yes 🙌. Being a data engineer and playing a role of Analyst many times, I can relate to this completely, every complex data analysis can be done with combination of aggregation and Subquery. When I was handtied with files duckdb came as a blessing and my data exploration goes on .
```

4

<iframe src="chrome-extension://cnjifjpddelmedmihgijeibhnjfabmlf/side-panel.html?context=iframe"></iframe>