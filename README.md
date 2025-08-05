# Teams 2.0 Cleanup Tool

**Author:** [That Bearded IT Guy](https://thatbeardeditguy.com)  
**Purpose:** Automates the cleanup of Microsoft Teams 2.0 caches and credentials to resolve stubborn sign-in loop issues.

---

## What It Does

- Stops all running Teams processes  
- Clears Teams cache (Local AppData)  
- Clears Windows IdentityCache and TokenBroker folders  
- Removes Teams and Microsoft-related credentials from Windows Credential Manager  
- Optionally downloads and reinstalls Teams with the latest installer

---

## Why You Might Need It

New Teams (Teams 2.0) moved its data to Local AppData and uses Windows authentication caches. When these caches get corrupted, clearing only the Teams folder will not fix sign-in loops. This script clears all the related data, allowing a clean reinstall.

---

## Usage

1. Download the script.  
2. Right-click and **Run with PowerShell as Administrator**.  
3. Follow the prompts (optionally reinstall Teams after cleanup).

---

## Disclaimer

Use at your own risk. This script is provided as-is with no warranties or guarantees. Test thoroughly before deploying in a production environment.

---

## Related Blog Post

Read the full article on my site: [The Microsoft Teams Sign-In Nightmare (and How I Finally Fixed It)](https://thatbeardeditguy.com/the-microsoft-teams-sign-in-nightmare-and-how-i-finally-fixed-it)


