local function get_projections(read_template)
  return {
    ['pyproject.toml|requirements.txt|*.py'] = {
      ['.pre-commit-config.yaml|*.pre-commit-config.yaml'] = {
        template = read_template('python/pre-commit-config.yaml'),
      },
      ['*__main__.py'] = {
        template = read_template('python/__main__.py'),
      },
      ['*cli*.py'] = {
        template = read_template('python/cli.py'),
      },
      ['*app*.py'] = {
        template = read_template('python/app.py'),
      },
      ['tests/test_*.py|test_*.py'] = {
        alternate = 'src/{}.py',
        type = 'test',
        template = read_template('python/test.py'),
      },
      ['__init__.py'] = {
        template = read_template('python/init.py'),
      },
      ['src/*.py|*.py'] = {
        alternate = 'tests/test_{}.py',
        type = 'source',
        template = read_template('python/main.py'),
      },
    },
  }
end

return get_projections
