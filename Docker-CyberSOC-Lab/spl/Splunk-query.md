# USEFUL SPL QUERY

To Remember: 

search
| filter
| transform
| sort

- To Built Timeline:

    index=sysmon
        | table _time EventData.ParentImage EventData.Image EventData.CommandLine
        | sort _time

    ![alt text](<../screenshots/Screenshot 2026-09-04 at 3.08.36 PM.png>)