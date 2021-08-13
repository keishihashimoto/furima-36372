# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


## itemsテーブル

| Column          | Type       | Options                        |
| --------------- | ---------- | ------------------------------ |
| name            | string     | null: false                    |
| description     | text       | null: false                    |
| category        | string     | null: false                    | 
| postage         | string     | null: false                    |
| shipment_source | string     | null: false                    |
| delivery        | string     | null: false                    |
| price           | integer    | null: false                    |
| stock           | integer    | null: false                    |
| user            | references | null: false, foreign_key: true |

### Association

- belongs_to :user

## usersテーブル

| Column             | Type    | Options     |
| ------------------ | ------- | ----------- |
| nickname           | string  | null: false |
| email              | string  | null: false |
| encrypted_password | text    | null: false |
| first_name         | string  | null: false |
| last_name          | string  | null: false |
| first_name_reading | string  | null: false |
| last_name_reading  | string  | null: false |
| birth_year         | integer | null: false |
| birth_month        | integer | null: false |
| birth_date         | integer | null: false |

### Association

- has_many :items