## Installation

You need ruby 2.7.1 to run this program.

1. Go to https://rvm.io/ and install relevant version
2. run `bundle` in the project directory
3. You should be ready!

## Running

`bin/run.rb` file can be used to run the program. It takes just one argument, which is a cron expression.

Example:

`ruby bin/run.rb '*/15 0 1,15 * 1-5 /usr/bin/find'`

The output should look like:
```
minute        0 15 30 45
hour          0
day of month  1 15
month         1 2 3 4 5 6 7 8 9 10 11 12
day of week   1 2 3 4 5
command       /usr/bin/find
```

## Testing

We use `rspec` for the tests so you can just type `rspec` in your console.
