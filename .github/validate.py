from collections import namedtuple
import json
import sys
import os


class Version:

    @staticmethod
    def parse(version):
        if version is None:
            return None
        return Version(*map(int, version.split(".")))

    def __init__(self, major, minor, patch):
        self.major = major
        self.minor = minor
        self.patch = patch

    def __gt__(self, other):
        if self.major > other.major:
            return True
        if self.major == other.major and self.minor > other.minor:
            return True
        if self.major == other.major and self.minor == other.minor and self.patch > other.patch:
            return True
        return False

    def __str__(self):
        return f"{self.major}.{self.minor}.{self.patch}"

def get_argv(i):
    return sys.argv[i] if len(sys.argv) > i else None

def validate_info():
    try:
        with open("info.json") as file:
            content = json.load(file)
    except:
        print("Could not find info.json")
        return False

    required_fields = [
        "name",
        "version",
        "title",
        "author",
        "factorio_version",
        "dependencies",
    ]
    for field in required_fields:
        if field not in content:
            print(f"Missing field {field}")
            return False

    previous_version = Version.parse(get_argv(1))
    if previous_version is None:
        print("Previous version was not provided, skipping version check")
        return True
    print(f"previous version was {previous_version}")
    version = Version.parse(content["version"])
    print(f"Current version is {version}")
    if not version > previous_version:
        print("The current version should be greater than the previous version")
        return False
    return True

def validate_changelog():
    if not os.path.isfile("changelog.txt"):
        # TODO Add check to make sure changelog contains the changes from the current version
        print("Missing changelog")
        return False
    return True

def validate_thumbnail():
    if not os.path.isfile("thumbnail.png"):
        print("Missing thumbnail")
        return False
    return True

def parse_locale_dir(language_directory):
    """Return a set of all keys across all .cfg files in a language directory."""
    keys = set()
    for filename in os.listdir(language_directory):
        if not filename.endswith(".cfg"):
            print(f"Found weird file {filename} in locale folder, skipping")
            continue
        path = os.path.join(language_directory, filename)
        current_section = None
        try:
            with open(path, encoding="utf-8") as file:
                for line in file:
                    if not line or line.startswith(";"):
                        continue
                    # Section header
                    if line.startswith("[") and line.endswith("]"):
                        current_section = line
                    # Locale key
                    elif "=" in line:
                        key, _ = line.split("=", 1)
                        full_key = f"{current_section}.{key}" if current_section else key
                        keys.add(full_key)
        except Exception as exception:
            print(f"Failed to parse {path}: {exception}")
    return keys

def validate_locales():
    locale_directory = "locale"
    if not os.path.isdir(locale_directory):
        print("No locale folder found")
        return False

    languages = [language_directory for language_directory in os.listdir(locale_directory) if os.path.isdir(os.path.join(locale_directory, language_directory))]
    if not languages:
        print("No languages found inside locale/")
        return False

    reference_lang = "en"
    if reference_lang not in languages:
        print("Warning: no English (en) locale found, using first language as reference")
        reference_lang = languages[0]

    reference_keys = parse_locale_dir(os.path.join(locale_directory, reference_lang))
    if not reference_keys:
        print(f"No keys found in reference locale: {reference_lang}")
        return False

    for language in languages:
        language_directory = os.path.join(locale_directory, language)
        keys = parse_locale_dir(language_directory)
        missing = reference_keys - keys
        extra = keys - reference_keys
        if missing:
            print(f"[{language}] Missing keys: {', '.join(sorted(missing))}")
            return False
        if extra:
            print(f"[{language}] Extra keys: {', '.join(sorted(extra))}")
            return False

    return True

def validate_mod_structure():
    return validate_info() and validate_changelog() and validate_thumbnail() and validate_locales()

if __name__ == "__main__":
    if not validate_mod_structure():
        print("Nope")
        sys.exit(1)
    print("Looks good to me")
    sys.exit(0)
