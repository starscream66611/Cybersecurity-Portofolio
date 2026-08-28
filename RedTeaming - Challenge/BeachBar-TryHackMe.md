# Beach Bar - TryhHackme - Red Team Practice

TryHackMe challenge

![alt text](<screenshot/Screenshot 2026-08-24 at 2.40.42 PM.png>)

given websites and the goal is to find the user flag and root flag.

- Nmap IP 10.49.181.131

    I start by doing nmap to see what port is open on that websites.

    ![alt text](<screenshot/Screenshot 2026-08-24 at 3.39.19 PM.png>)

    from this screenshot there's 2 ports open which is ssh and http

    this two port are very very vulnerable if we want to bypass the authentication.

- Checking the HTML code

    Before trying any authentication bypass im goin to see the page source.

    and here's what i found.
    ![alt text](<screenshot/Screenshot 2026-08-24 at 3.43.22 PM.png>)

    The interesting part here is the comment:
    "staff note: the demo DJ login is still enabled for the soft opening. dj / dj  -- swap this before the season starts (ticket BAR-7)"

    username: dj
    password: dj

    ![alt text](<screenshot/Screenshot 2026-08-24 at 3.46.23 PM.png>)

    there's a message to export the current playlist, tweak it and import it. here's the yaml file

    ![alt text](<screenshot/Screenshot 2026-08-24 at 3.49.24 PM.png>)

    im trying to tweak it and import it and see the website behavior.

    ![alt text](<screenshot/Screenshot 2026-08-24 at 3.58.30 PM.png>)

    i added new song, and the file loaded that song so the import is working.

    but, there's an input section. Im trying to do a little scripting and see wat happens.

    