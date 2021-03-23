# Explainer: Origin-bound one-time codes delivered via SMS

- [Draft spec](https://wicg.github.io/sms-one-time-codes/) (eds. [Theresa O'Connor](https://github.com/hober) from Apple and [Sam Goto](https://github.com/samuelgoto) from Google)
- [Issue tracker](https://github.com/WICG/sms-one-time-codes/issues/)
- You're welcome to [contribute](CONTRIBUTING.md)!

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Introduction](#introduction)
  - [Deficiencies of the status quo](#deficiencies-of-the-status-quo)
- [Goals](#goals)
  - [Non-goals](#non-goals)
- [Proposal](#proposal)
- [Benefits](#benefits)
- [Alternative approaches](#alternative-approaches)
  - [No special syntax (status quo)](#no-special-syntax-status-quo)
- [Stakeholder Feedback](#stakeholder-feedback)
- [Acknowledgements](#acknowledgements)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Introduction

Many websites make use of **one-time codes** for authentication.

SMS is a popular mechanism for delivering such codes to users, but using SMS to deliver one-time codes can be risky.

This proposal attempts to reduce some of the risks associated with SMS delivery of one-time codes. It does not attempt to reduce or solve all of them. For instance, it doesn't solve the SMS delivery hijacking risk, but it does attempt to reduce the phishing risk.

### Deficiencies of the status quo

Suppose a user receives the message "747723 is your ExampleCo authentication code." It's possible, even likely, that 747723 is a one-time code for use on `https://example.com`. But because there is no standard text format for SMS delivery of one-time codes, systems which want to make programmatic use of such codes must rely on heuristics, both to locate the code in the message and to associate the code with a website. Heuristics are prone to failure and may even be hazardous.

End users shouldn't have to manually copy-and-paste one-time codes from SMSes to their browser, and codes sent by a site should only be provided to the actual site which sent it.

## Goals

The goals of this proposal are to

1. eliminate the need to rely on heuristics for programmatic extraction of one-time codes from SMS messages, and to
2. reliably associate one-time codes intended for use on a specific website with that site.

### Non-goals

This proposal does not set out to

1. expose the contents of arbitrary SMS messages to websites, or to
2. restrict the sources from which browsers may source one-time codes for providing them to websites.

## Proposal

To address this, we propose a lightweight text format that services may use for delivering one-time codes over SMS. The format associates the code with the website's origin. We call such codes **origin-bound one-time codes**, and we call such messages **origin-bound one-time code messages**.

The message format is about as simple as it gets. Messages begin with (optional) human-readable text. The last line of the message contains the origin and the code, with the prefix characters `"@"` and `"#"` denoting which is which. Here's an example:

```text
747723 is your ExampleCo authentication code.
    
@example.com #747723
```

In this example,

* `"https://example.com"` is the origin the code is associated with,
* `"747723"` is the code, and
* `"747723 is your ExampleCo authentication code.\n\n"` is human-readable explanatory text.

The characters `"@"` and `"#"` identify the origin and the code, respectively. (We can always introduce additional prefix characters in the future if it turns out we need to include additional information in these messages.)

Some sites use third-party `iframe`s for authentication. In such cases, the third-party `iframe`'s origin can be specified using the same `"@"` field after the code.

```text
747723 is your ExampleCo authentication code.

@example.com #747723 @ecommerce.example
```

In this example,

* `"https://example.com"` is the origin the code is associated with,
* `"747723"` is the code,
* `"https://ecommerce.example"` is the origin of the third-party `iframe`, and
* `"747723 is your ExampleCo authentication code.\n\n"` is human-readable explanatory text.

## Benefits

Adoption of this format would improve the reliability of systems which today heuristically extract one-time codes from SMS, with clear end-user benefit. It improves reliability of both extracting the code and also associating that code with an origin.

Adoption of this proposal could improve the number of services on which a browser can offer assistance with providing SMS one-time codes to websites (e.g. an AutoFill feature), and could reduce the odds users would enter one-time codes delivered over SMS on sites other than the originating one.

## Alternative approaches

### No special syntax (status quo)

We believe the status quo provides insufficient programmability (because it relies on heuristics) and, in particular, many typical SMS one-time code message formats in the wild lack reliable origin information.

## Stakeholder Feedback

- Safari: Positive.
- Chrome: Positive.
- Firefox: Mixed signals. See [mozilla/standards-positions#152](https://github.com/mozilla/standards-positions/issues/152) for some relevant discussion.

## Acknowledgements

Many thanks to
Aaron Parecki,
Eric Shepherd,
Eryn Wells,
Jay Mulani,
Paul Knight,
Ricky Mondello,
and
Steven Soneff
for their valuable feedback on this proposal.
