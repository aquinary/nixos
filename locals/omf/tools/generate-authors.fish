#!/nix/store/klnj5f6mjd8fa7s7qgm8cw8y76gdjrrj-fish-3.5.1/bin/fish
# This script generates the AUTHORS file from Git history.

echo '# This file lists all individuals having contributed content to the repository.'
echo '# This list was auto-generated from Git history.'
echo

function list_authors
    # List existing authors
    git show HEAD:AUTHORS | sed -e '/^$/d' -e '/^#/d'

    # List any new authors
    git log --format='%aN <%aE>' | awk '
    {
        pos = index($0, "<");
        name = substr($0, 0, pos - 2);
        email = substr($0, pos + 1, length($0) - pos - 1);
        names[name]++;
        emails[email]++;
        if (names[name] == 1 && emails[email] == 1) {
            print $0;
        }
    }
    '
end

list_authors | env LC_ALL=C.UTF-8 sort -uf
