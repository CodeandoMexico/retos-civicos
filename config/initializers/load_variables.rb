env = YAML.load_file("#{Rails.root}/config/environment_variables.yml")[Rails.env]
GITHUB_KEY = env['github']['key']
GITHUB_SECRET = env['github']['secret']

