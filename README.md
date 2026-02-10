# scrapy-patchwright: Patchright integration for Scrapy

![version](https://img.shields.io/pypi/v/scrapy-patchwright.svg)
![Scrapy: 2.14+](https://img.shields.io/badge/Scrapy-2.14+-blue)
![version](https://img.shields.io/badge/scrapy--playwright-v0.0.46+-darkcyan)
![version](https://img.shields.io/badge/Python-3.12+-blue)

scrapy-patchwright is a [scrapy-patchwright](https://github.com/scrapy-plugins/scrapy-patchwright) variant version using [patchright](https://github.com/Kaliiiiiiiiii-Vinyzu/patchright-python) that become browser stealth against those anti-bot websites.

## Installation

`scrapy-patchwright` is available on PyPI and can be installed with `pip`:

```shell
pip install scrapy-patchwright
```

As patchright stated, it only supports patching Chromium browser

> [!IMPORTANT]
>
> Patchright only patches CHROMIUM based browsers. Firefox and Webkit are not supported.

Therefore installing Chromium browser is all we need.

```shell
patchright install chromium
```

## Activation

### Download handler

Replace the default `http` and/or `https` Download Handlers through [`DOWNLOAD_HANDLERS`](https://docs.scrapy.org/en/latest/topics/settings.html):

```python
# settings.py
DOWNLOAD_HANDLERS = {
    "http": "scrapy_patchwright.handler.ScrapyPlaywrightDownloadHandler",
    "https": "scrapy_patchwright.handler.ScrapyPlaywrightDownloadHandler",
}
```

If this handler is only used by specified spiders, you can add custom settings in your spider like this:

```python
import scrapy

class MySpider(scrapy.Spider):
    custom_settings = {
        'DOWNLOAD_HANDLERS': {
            "http": "scrapy_patchwright.handler.ScrapyPlaywrightDownloadHandler",
            "https": "scrapy_patchwright.handler.ScrapyPlaywrightDownloadHandler",
        },
    }
```

Note that the `ScrapyPlaywrightDownloadHandler` class inherits from the default `http/https` handler. Unless explicitly marked, requests will be processed by the regular Scrapy download handler.

### Twisted reactor

[Install the `asyncio`-based Twisted reactor](https://docs.scrapy.org/en/latest/topics/asyncio.html#installing-the-asyncio-reactor):

```python
# settings.py
TWISTED_REACTOR = "twisted.internet.asyncioreactor.AsyncioSelectorReactor"
```

This is the default in new projects since [Scrapy 2.7](https://github.com/scrapy/scrapy/releases/tag/2.7.0).

## Common Settings

This is the commonly use case in your spider. Learn more from scrapy-patchwright documentations.

```python
custom_settings = {
    'PLAYWRIGHT_PROCESS_REQUEST_HEADERS': None, # This is mandatory!
    'PLAYWRIGHT_LAUNCH_OPTIONS': {
        'headless': False,
        'channel': 'chrome',
    },
    'PLAYWRIGHT_CONTEXTS': {
        'persistent': {
            'user_data_dir': 'playwright_data',
            'ignore_https_errors': True,
        }
    }
}
```

## Basic Usage

Same as [scrapy-playwright](https://github.com/scrapy-plugins/scrapy-playwright?tab=readme-ov-file#basic-usage).

```python
import scrapy

class MySpider(scrapy.Spider):
    name = "awesome"

    def start_requests(self):
        # GET request
        yield scrapy.Request("https://httpbin.org/get", meta={"playwright": True})
        # POST request
        yield scrapy.FormRequest(
            url="https://httpbin.org/post",
            formdata={"foo": "bar"},
            meta={"playwright": True},
        )

    def parse(self, response, **kwargs):
        # 'response' contains the page as seen by the browser
        return {"url": response.url}
```



