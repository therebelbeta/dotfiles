"""
List available AWS profiles, and the roles they assume.
"""

import os.path
from ConfigParser import RawConfigParser, NoOptionError

def main():
    parser = RawConfigParser()
    parser.read(os.path.expanduser("~/.aws/config"))

    profile_names = []
    for section in parser.sections():
        if section.startswith('profile '):
            profile_names.append(section.split(' ')[1])

    max_length = max(len(profile) for profile in profile_names)
    for profile in sorted(profile_names):
        section = 'profile %s' % profile
        try:
            role_arn = parser.get(section, 'role_arn')
        except NoOptionError:
            print profile
        else:
            role = role_arn.split('/')[1]
            padding = ' ' * (max_length - len(profile) + 3)
            print '%s%s(%s)' % (profile, padding, role)

if __name__ == '__main__':
    main()
