---
library: psych
---
# class Psych::Nodes::Stream < Psych::Nodes::Node

YAML stream を表すクラス。

YAML の AST のルートノードとなるオブジェクトのクラス。
このノードの子ノードは1個以上でなければならず、また
[c:Psych::Nodes::Document] オブジェクトでなければなりません。

## Class Methods
### def new(encoding = Psych::Nodes::Stream::UTF8) -> Psych::Nodes::Stream

Psych::Nodes::Stream オブジェクトを生成して返します。

encoding には stream に使われるエンコーディングを指定します。
以下のいずれかを指定します。
  - [m:Psych::Nodes::Node::UTF8]
  - [m:Psych::Nodes::Node::UTF16BE]
  - [m:Psych::Nodes::Node::UTF16LE]

- **param** `encoding` -- エンコーディング

## Instance Methods
### def encoding -> Integer
stream に使われるエンコーディングを返します。

- **SEE** [m:Psych::Nodes::Stream#encoding=]

### def encoding=(enc)
stream に使われるエンコーディングを指定します。

以下のいずれかを指定します。
  - [m:Psych::Nodes::Node::UTF8]
  - [m:Psych::Nodes::Node::UTF16BE]
  - [m:Psych::Nodes::Node::UTF16LE]

- **param** `enc` -- 設定するエンコーディング
- **SEE** [m:Psych::Nodes::Stream#encoding]

## Constants
### const ANY -> Integer
任意のエンコーディングを表す値。

[m:Psych::Parser::ANY] と同じ値です。

### const UTF8 -> Integer
UTF8 エンコーディングを表します。

[m:Psych::Parser::UTF8] と同じ値です。

- **SEE** [m:Psych::Nodes::Stream.new]

### const UTF16LE -> Integer
UTF16LE エンコーディングを表します。

[m:Psych::Parser::UTF16LE] と同じ値です。

- **SEE** [m:Psych::Nodes::Stream.new]

### const UTF16BE -> Integer
UTF16BE エンコーディングを表します。

[m:Psych::Parser::UTF16BE] と同じ値です。

- **SEE** [m:Psych::Nodes::Stream.new]

