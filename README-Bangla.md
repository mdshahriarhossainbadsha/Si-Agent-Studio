# Si-Agent-Studio

OpenClaw এবং OpenWebUI-ভিত্তিক লোকাল AI Agent Studio।

## প্রয়োজনীয় সফটওয়্যার

- Windows 10 অথবা Windows 11
- Node.js LTS
- Git
- Docker Desktop
- Internet connection

## ইনস্টলেশন

1. `Setup.bat` চালান।
2. `Add API Key.bat` চালান।
3. পছন্দের AI provider নির্বাচন করুন।
4. API key লিখুন।
5. `Start Si Agent.bat` চালান।
6. Browser নির্বাচন করুন।

## ফাইলগুলোর কাজ

| ফাইল | কাজ |
|---|---|
| `Setup.bat` | Node.js, Git, folder এবং dependency setup |
| `Add API Key.bat` | API key সংরক্ষণ ও status দেখা |
| `Start Si Agent.bat` | OpenClaw এবং OpenWebUI চালু করা |
| `View Log.bat` | Live log দেখা |
| `Uninstall.bat` | Local dependency, log ও data পরিষ্কার করা |
| `docker-compose.yml` | OpenWebUI container চালানো |

## OpenWebUI

সফলভাবে চালু হলে সাধারণত নিচের ঠিকানায় পাওয়া যাবে:

http://localhost:3000

## API Key Security

API key `config/agent.env` ফাইলে সংরক্ষিত হয়। এই ফাইলটি কখনো GitHub-এ commit করবেন না।

প্রয়োজনে Windows Credential Manager, 1Password, Vault অথবা অন্য কোনো secret manager ব্যবহার করুন।

## সমস্যা সমাধান

### Node.js পাওয়া যাচ্ছে না

Node.js LTS ইনস্টল করে আবার `Setup.bat` চালান।

### Docker পাওয়া যাচ্ছে না

Docker Desktop ইনস্টল এবং চালু করুন। তারপর আবার `Start Si Agent.bat` চালান।

### Log দেখা

`View Log.bat` চালিয়ে OpenClaw অথবা OpenWebUI log নির্বাচন করুন।

### সম্পূর্ণ পরিষ্কার করা

`Uninstall.bat` চালান। এটি API key, logs, local data এবং `node_modules` মুছে দেবে।
