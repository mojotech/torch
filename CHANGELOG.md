# Change Log

## [v2.0.0-rc.1](https://github.com/infinitered/torch/tree/v2.0.0-rc.1) (2018-04-13)
[Full Changelog](https://github.com/infinitered/torch/compare/v1.0.0-rc.6...v2.0.0-rc.1)

**Implemented enhancements:**

- Add ability to set default sort order [\#32](https://github.com/infinitered/torch/issues/32)
- Add support for read-only fields [\#25](https://github.com/infinitered/torch/issues/25)

**Fixed bugs:**

- Fix Javascript error when Torch/Pikaday element is not on page [\#64](https://github.com/infinitered/torch/issues/64)
- Uncaught TypeError: Cannot read property 'register' of undefined [\#10](https://github.com/infinitered/torch/issues/10)

**Closed issues:**

- mix torch.install - Phoenix.HTML.Form.date\_input/3 conflicts with local function [\#81](https://github.com/infinitered/torch/issues/81)
- Support Phoenix 1.3 [\#78](https://github.com/infinitered/torch/issues/78)
- Docs incorrect regarding css setup.  [\#72](https://github.com/infinitered/torch/issues/72)
- last release Phoenix 1.3... throws error [\#70](https://github.com/infinitered/torch/issues/70)
- Brunch not building correct JS imports [\#59](https://github.com/infinitered/torch/issues/59)

**Merged pull requests:**

- Fix date input conflicts [\#82](https://github.com/infinitered/torch/pull/82) ([dalpo](https://github.com/dalpo))
- Upgrade torch to v2.0 [\#79](https://github.com/infinitered/torch/pull/79) ([zberkom](https://github.com/zberkom))
- Enusre form\#filters exists before attempting to add an event listener [\#66](https://github.com/infinitered/torch/pull/66) ([silasjmatson](https://github.com/silasjmatson))
- \[\#62\] Add the initial version of Brunch & Webpack guides [\#63](https://github.com/infinitered/torch/pull/63) ([zberkom](https://github.com/zberkom))
- Update Webpack config [\#61](https://github.com/infinitered/torch/pull/61) ([codeithuman](https://github.com/codeithuman))
- Make `node\_module` requires relative [\#58](https://github.com/infinitered/torch/pull/58) ([danielberkompas](https://github.com/danielberkompas))
- Add support for read-only fields [\#56](https://github.com/infinitered/torch/pull/56) ([darinwilson](https://github.com/darinwilson))
- Add ability to set default sort order [\#55](https://github.com/infinitered/torch/pull/55) ([mlaco](https://github.com/mlaco))

## [v1.0.0-rc.6](https://github.com/infinitered/torch/tree/v1.0.0-rc.6) (2017-05-03)
[Full Changelog](https://github.com/infinitered/torch/compare/v1.0.0-rc.5...v1.0.0-rc.6)

**Fixed bugs:**

- Clicking pagination arrows resets sort. [\#36](https://github.com/infinitered/torch/issues/36)
- Date Range Filter: match error if start or end date isn't selected [\#34](https://github.com/infinitered/torch/issues/34)
- Clicking on pagination link reset filters [\#31](https://github.com/infinitered/torch/issues/31)
- `page` query string is blank when using the sorting [\#22](https://github.com/infinitered/torch/issues/22)
- Filter \<select\> elements all have the same id and name [\#21](https://github.com/infinitered/torch/issues/21)
- Normalize CSS file should only affect torch markup [\#13](https://github.com/infinitered/torch/issues/13)
- Bugfix/date range filter [\#38](https://github.com/infinitered/torch/pull/38) ([zberkom](https://github.com/zberkom))
- Pagination arrows and number links reset sort and query [\#37](https://github.com/infinitered/torch/pull/37) ([zberkom](https://github.com/zberkom))

**Closed issues:**

- Example app post index controller error [\#47](https://github.com/infinitered/torch/issues/47)
- ArgumentError with filter\_date\_input [\#42](https://github.com/infinitered/torch/issues/42)
- Move example app into separate repo or subdirectory [\#24](https://github.com/infinitered/torch/issues/24)

**Merged pull requests:**

- Update dependencies to resolve conflicts [\#54](https://github.com/infinitered/torch/pull/54) ([zberkom](https://github.com/zberkom))
- Fix badge [\#53](https://github.com/infinitered/torch/pull/53) ([GantMan](https://github.com/GantMan))
- Add premium support note to README.md [\#51](https://github.com/infinitered/torch/pull/51) ([codeithuman](https://github.com/codeithuman))
- \[fix\] remove padding before code block. [\#50](https://github.com/infinitered/torch/pull/50) ([Debetux](https://github.com/Debetux))
- Move css, js to idiomatic assets folder [\#49](https://github.com/infinitered/torch/pull/49) ([danielberkompas](https://github.com/danielberkompas))
- \[\#13\] Namespace normalize CSS [\#48](https://github.com/infinitered/torch/pull/48) ([danielberkompas](https://github.com/danielberkompas))
- Add Slackin badge [\#45](https://github.com/infinitered/torch/pull/45) ([mlaco](https://github.com/mlaco))
- Add test template [\#44](https://github.com/infinitered/torch/pull/44) ([lboekhorst](https://github.com/lboekhorst))
- append the lists instead of string concatenation [\#43](https://github.com/infinitered/torch/pull/43) ([hanskenis](https://github.com/hanskenis))
- Add badges [\#41](https://github.com/infinitered/torch/pull/41) ([danielberkompas](https://github.com/danielberkompas))
- Run ecto.setup in bin/setup [\#40](https://github.com/infinitered/torch/pull/40) ([danielberkompas](https://github.com/danielberkompas))
- \[\#22\] Fix query string [\#39](https://github.com/infinitered/torch/pull/39) ([danielberkompas](https://github.com/danielberkompas))
- Reorganize repo as a lib with example, rather than an umbrella app [\#33](https://github.com/infinitered/torch/pull/33) ([darinwilson](https://github.com/darinwilson))

## [v1.0.0-rc.5](https://github.com/infinitered/torch/tree/v1.0.0-rc.5) (2016-10-28)
[Full Changelog](https://github.com/infinitered/torch/compare/v1.0.0-rc.4...v1.0.0-rc.5)

**Merged pull requests:**

- Upgrade to latest version of Credo [\#30](https://github.com/infinitered/torch/pull/30) ([darinwilson](https://github.com/darinwilson))

## [v1.0.0-rc.4](https://github.com/infinitered/torch/tree/v1.0.0-rc.4) (2016-09-27)
[Full Changelog](https://github.com/infinitered/torch/compare/v1.0.0-rc.3...v1.0.0-rc.4)

**Fixed bugs:**

- Javascript Errors in Safari [\#28](https://github.com/infinitered/torch/issues/28)
- Pagination `end\_page/3` is broken [\#26](https://github.com/infinitered/torch/issues/26)

**Merged pull requests:**

- Convert NodeList objects into an Array before using forEach [\#29](https://github.com/infinitered/torch/pull/29) ([silasjmatson](https://github.com/silasjmatson))
- Fix `end\_page/3` math issue [\#27](https://github.com/infinitered/torch/pull/27) ([codeithuman](https://github.com/codeithuman))

## [v1.0.0-rc.3](https://github.com/infinitered/torch/tree/v1.0.0-rc.3) (2016-09-19)
[Full Changelog](https://github.com/infinitered/torch/compare/v1.0.0-rc.2...v1.0.0-rc.3)

**Closed issues:**

- Add support to ellipsize pagination links [\#19](https://github.com/infinitered/torch/issues/19)

**Merged pull requests:**

- Restrict pagination links to groups of 10 [\#23](https://github.com/infinitered/torch/pull/23) ([darinwilson](https://github.com/darinwilson))

## [v1.0.0-rc.2](https://github.com/infinitered/torch/tree/v1.0.0-rc.2) (2016-08-15)
[Full Changelog](https://github.com/infinitered/torch/compare/v1.0.0-rc.1...v1.0.0-rc.2)

**Closed issues:**

- App.js included at top of layout fires fires too early [\#12](https://github.com/infinitered/torch/issues/12)
- Boolean field type produces 3 options \(true, false, blank\) [\#11](https://github.com/infinitered/torch/issues/11)
- Readme contains incorrect command [\#9](https://github.com/infinitered/torch/issues/9)
- Filtrex is missing from install dependencies [\#8](https://github.com/infinitered/torch/issues/8)

**Merged pull requests:**

- Move app.js include to bottom of layout file [\#18](https://github.com/infinitered/torch/pull/18) ([darinwilson](https://github.com/darinwilson))
- Remove prompt from boolean select field [\#17](https://github.com/infinitered/torch/pull/17) ([darinwilson](https://github.com/darinwilson))
- Fixes for initial setup [\#16](https://github.com/infinitered/torch/pull/16) ([darinwilson](https://github.com/darinwilson))
- Fix README errors [\#15](https://github.com/infinitered/torch/pull/15) ([darinwilson](https://github.com/darinwilson))
- Fix out-of-date filtrex dependency [\#14](https://github.com/infinitered/torch/pull/14) ([darinwilson](https://github.com/darinwilson))
- Add Credo for linting [\#7](https://github.com/infinitered/torch/pull/7) ([danielberkompas](https://github.com/danielberkompas))

## [v1.0.0-rc.1](https://github.com/infinitered/torch/tree/v1.0.0-rc.1) (2016-07-15)
[Full Changelog](https://github.com/infinitered/torch/compare/v0.2.0-rc.5...v1.0.0-rc.1)

**Merged pull requests:**

- Slim support [\#6](https://github.com/infinitered/torch/pull/6) ([danielberkompas](https://github.com/danielberkompas))
- Boolean Filters, Association Support [\#5](https://github.com/infinitered/torch/pull/5) ([danielberkompas](https://github.com/danielberkompas))
- Add filter UI [\#4](https://github.com/infinitered/torch/pull/4) ([codeithuman](https://github.com/codeithuman))
- Add table styles [\#3](https://github.com/infinitered/torch/pull/3) ([codeithuman](https://github.com/codeithuman))
- Add toolbar styles [\#2](https://github.com/infinitered/torch/pull/2) ([codeithuman](https://github.com/codeithuman))
- Add CSS structure and header styles [\#1](https://github.com/infinitered/torch/pull/1) ([codeithuman](https://github.com/codeithuman))

## [v0.2.0-rc.5](https://github.com/infinitered/torch/tree/v0.2.0-rc.5) (2016-06-28)
[Full Changelog](https://github.com/infinitered/torch/compare/v0.2.0-rc.4...v0.2.0-rc.5)

## [v0.2.0-rc.4](https://github.com/infinitered/torch/tree/v0.2.0-rc.4) (2016-06-28)
[Full Changelog](https://github.com/infinitered/torch/compare/v0.2.0-rc.3...v0.2.0-rc.4)

## [v0.2.0-rc.3](https://github.com/infinitered/torch/tree/v0.2.0-rc.3) (2016-06-28)
[Full Changelog](https://github.com/infinitered/torch/compare/0.2.0-rc.2...v0.2.0-rc.3)

## [0.2.0-rc.2](https://github.com/infinitered/torch/tree/0.2.0-rc.2) (2016-06-28)
[Full Changelog](https://github.com/infinitered/torch/compare/0.2.0-rc.1...0.2.0-rc.2)

## [0.2.0-rc.1](https://github.com/infinitered/torch/tree/0.2.0-rc.1) (2016-06-28)
[Full Changelog](https://github.com/infinitered/torch/compare/v0.1.0...0.2.0-rc.1)

## [v0.1.0](https://github.com/infinitered/torch/tree/v0.1.0) (2016-06-27)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*