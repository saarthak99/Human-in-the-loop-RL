version_info = (0, 1, 0)
# format:
# ('hmn_adv_saferl_major', 'hmn_adv_saferl_minor', 'shmn_adv_saferl_patch')

def get_version():
    "Returns the version as a human-format string."
    return '%d.%d.%d' % version_info

__version__ = get_version()
