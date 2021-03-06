Platform Event Wrapper - Work In Progress (Migrated to Sf-Cross-Cutting-Concerns)
=================================================================================

See Document [PDF](https://github.com/bjanderson70/sf-platform-events/blob/master/PE-Framework.pdf) as it is most up-to-date. The platform wrapper should work in your environment. However, there are updates to be made but time and work constraints are impacting deliverable. This project will deploy but some features (classes) will be overwritten by cross-cutting-concerns. **Do NOT** install this package over the sf-cross-cutting-concerns! As it will overwrite crucial aspects.

**I have updated the sf-cross-cutting-concerns to include Platform Events and CDC. Future enhancements will be done in sf-cross-cutting-concerns.** as the overlay of the two are becoming more apparent. Also, provides better continuity between these aspects.

**This framework will be deprecated** as the logic has now moved into sf-cross-cutting-concerns. You can still use and augment the base functionality; however, updates will be done in **sf-cross-cutting-concerns**.

Note the following **changes are done** (and a separate branch in sf-cross-cutting-concern contains these changes):
 * This package changed the prefix to **accc_** to become and add-on package to the *Cross Cutting Concerns* package. 
 * In addition, will be adding Summer '19 features **AsyncOperationEvent**; however, this will **tie this package to minimum version 46**. 
 * Updates include more data written into the BigObject (i.e. replayids and operation ids) for recovery on a queued high-volume event. 
 * The template will be started but will probably not be done before the merge.
 * Incorporate Trigger Handling for Platform Events and CDC
 * Control Event Batching Size (initially via attributes before moving into CMDT)
 
 Additional work is needed to handle AsyncOperationEvent and provide more robustness in the consumer.

Deploy to Salesforce
====================

<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

What is it?
===========

This unmanaged package wraps the publish and subscribe mechanism in Salesforce.
It provides the ability change behavior at runtime, via Dependency Injection, as
well as changing behavior via extensions. Also, allow the ability to handle regular platform events and Change Data Capture Events. This way you can incorporate a [trigger handling mechanism](https://github.com/bjanderson70/sf-trigger-handling); which allows for dependency injection.

What is the value?
==================

Without some framework, or extensible tools, platform events are piecemealed,
forgotten, or a mish-mash of incongruous parts. It provides a consistent and
manageable control of publishing and subscribing to platform events; both
high-volume events and Change Data Capture events.

The value lies in being consistent, reliable, reusable and flexible.

How does it works?
==================

Defining a set of common interfaces and custom metadata within the Platform
Event framework allows one to change/augment aspects at different
levels/granularity. First, let’s define some of the salient components and their
functions before we walk through a code-snippet.

Note: Use of Big Object for platform event repo -- controlled via custom metadata

Salient Components
------------------

The Platform Event Wrapper provides six basic components:

| Component                   | Function                                                                                                                       |
|-----------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| accc_IEventHandler           | Defines the behavior for a Publisher or Consumer                                                                               |
| accc_IPlatformEventModel     | Is a container for handling publish or subscription service                                                                    |
| accc_PlatformEvtBuilder      | Builds the model based on custom metadata, if defined, or uses defaults                                                        |
| accc_IProcessEventHandlers   | Container of handlers (log, success, error, alert)                                                                             |
| accc_PlatformEventAttrs      | Attributes used to manage logging (high-volume or standard), alerts, retries, validations, etc. of the publish/consume process |
| accc_PlatformEvtMdtDataModel | Provides a wrapper around the custom-metadata (DAO, Data Access Object), *accc_Platform_Event_Binding__mdt*                     |

A static class diagram brings this into more clarity.

Figure 1 Static Class Diagram

Platform Event Model
--------------------

The Platform Event Model, *accc_IPlatformEventModel*, defines the behavior for
processing platform events for publish or consumption.

Figure 2 Platform Event Model

Code Snippet / Example
----------------------

This code snippet, publishes an event, *pe_test__e*.

Steps 1 – 6 are described as follows (Step 1, is optional),

|   | Code                                                                                  | Comment                                                                                                                                                                                                                                                                                                                                                                            |
|---|---------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1 | **accc_PlatformEventAttrs** attributes = new accc_PlatformEventAttrs();                 | Create the default attributes (optional). See Platform Attributes                                                                                                                                                                                                                                                                                                                  |
| 2 | **accc_PlatformEvtBuilder** builder = new accc_PlatformEvtBuilder(‘pe_test__e','test',attributes); | Create a platform event builder. The event name, ‘*pe_test__e’,* along with the environment, ‘test’, is looked up in the custom metadata. The custom metadata may contain, five handlers. Handlers are classes that perform the following: (1) Log instrumentation information (2) Error information, that may occur (3) Log Success (4) Alert of steps being performed. (5) Store event |
| 3 | **accc_IEventHandler** publisher = builder.buildPublisher();                           | From step 2, the builder knows if there are any special handlers (other than the default) defined in the custom metadata. Publisher follow the process log, check, alert and publish.                                                                                                                                                                                              |
| 4 | **accc_IPlatformEventModel** model = builder.build(publisher);                         | From step 2, we can build the model. The model holds the four handlers, the event handler (publisher) and attributes that control the behavior.                                                                                                                                                                                                                                    |
| 5 | **List\<pe_test__e\>** pe=new List\<pe_test__e\> {new pe_test__e ()};                 | Create the collection of events to publish                                                                                                                                                                                                                                                                                                                                         |
| 6 | **model.process(pe)**);                                                               | Publish the event, returning true, if successful; otherwise false.                                                                                                                                                                                                                                                                                                                 |
|   |                                                                                       |                                                                                                                                                                                                                                                                                                                                                                                    |
|   |                                                                                       |                                                                                                                                                                                                                                                                                                                                                                                    |


Steps 1 – 5 are described for consuming an event (within a Trigger Handler) are as follows (Step 1, is optional),

|   | Code                                                                                  | Comment                                                                                                                                                                                                                                                                                                                                                                            |
|---|---------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1 | **accc_PlatformEventAttrs** attributes = new accc_PlatformEventAttrs();                 | Create the default attributes (optional). See Platform Attributes                                                                                                                                                                                                                                                                                                                  |
| 2 | **accc_PlatformEvtBuilder** builder = new accc_PlatformEvtBuilder(‘pe_test__e','test',attributes); | Create a platform event builder. The event name, ‘*pe_test__e’,* along with the environment, ‘test’, is looked up in the custom metadata. The custom metadata may contain, five handlers. Handlers are classes that perform the following: (1) Log instrumentation information (2) Error information, that may occur (3) Log Success (4) Alert of steps being performed. (5) Store event |
| 3 | **accc_IEventHandler** consumer = builder.buildConsumer();                           | From step 2, the builder knows if there are any special handlers (other than the default) defined in the custom metadata. Consumer follow the process log, check, alert and consume.                                                                                                                                                                                              |
| 4 | **accc_IPlatformEventModel** model = builder.build(consumer);                         | From step 2, we can build the model. The model holds the four handlers, the event handler (consumer) and attributes that control the behavior.                                                                                                                                                                                                                                    |
| 5 | **model.process(pe)**);                                                               | Consume the event, returning true, if successful; otherwise false.                                                                                                                                                                                                                                                                                                                 |
|   |                                                                                       |                                                                                                                                                                                                                                                                                                                                                                                    |
|   |                                                                                       |                                                                                                                                                                                                                                                                                                                                                                                    |


Custom Metadata
===============

In the custom metadata type below (**Apex Code Configurations),** three
environments (based on the ‘*Label’*) are defined with three different runtime
environments.

1.  **[DEBUG]** *a Sandbox (not running in a Unit Test)*

2.  **[PROD]** *Not a sandbox and not a Test procedure*

3.  **[TEST]** *i.e. Test.IsRunning*

Appendix: Publish Sequence Diagram
==================================

Platform Attributes
===================

Platform attributes class, *accc_PlatformEventAttrs*, helps control functionality
of the process of publishing and subscription. The table below breaks down the
attributes and purpose. The names are defined in the class,
*PlatformEventAttrs.cls,* and shown bellows.

| Name                  | Value                                                            | Comment                                                                                                                                                                                                                                                        |
|-----------------------|------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| SERIALIZE_EVENTS_s    | Boolean                                                          | If true, converts the incoming List of events into JSON. The JSON is passed into the log handler for processing.                                                                                                                                               |
| EVENT_LOGGING_s       | enum EventLogging { ALL, ON_ERROR, ON_SUCCESS, ON_LOG }          | What information to log                                                                                                                                                                                                                                        |
| RETRY_COUNT_s         | **Integer**, the value between 1 and 9 (inclusive), default is 5 | Number of retries; the default is 5. Retries occur ONLY for subscribers. Within a trigger there may be an occurrence (due to latency) that had not occurred. Thus, an *EventBus.RetryException* can be thrown. The consumer will handle up-to the retry-count. |
| CHECK_EVENT_NAME_s    | Boolean, default true                                            | Checks to determine if the event name passed in is correct.                                                                                                                                                                                                    |
| ADD_INSTRUMENTATION_s | Boolean, default is true                                         | Gather instrumentation (start-time, end-time). The information is passed along to the log handler                                                                                                                                                              |
|  EVENT_STORING_s            |  Boolean, default is true                      |   Store event into Big Object                                                                                                                                                                                                                                                             |
|                       |                                                                  |                                                                                                                                                                                                                                                                |

Users can change the behavior with the use of a Map\<String,Object\>. In fact,
the defaults are defined below.

Figure 4 Default Attributes

Custom Metadata
===============

The Platform Event Wrapper uses a custom metadata,
*accc_Platform_Event_Binding__mdt*, to lookup the event information. The
information contains the following fields:

| Label           | API Name           | Type                             | Comment                                                                                                                                                                |
|-----------------|--------------------|----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Active          | Active__c          | Checkbox                         | Allow execution. If inactive the event is not handled (published or consumed)                                                                                          |
| Alert Handler   | Alert_Handler__c   | Text(255)                        | The alert handler will be called at various steps performed by the consumer or the publisher                                                                           |
| Consumer        | Consumer__c        | String                           | The consumer is how one decides to consume an event. There are hooks to override behavior, as needed.                                                                  |
| Environment     | Environment__c     | Picklist (test,debug,production) | Which environment this event will run in                                                                                                                               |
| Error Handler   | Error_Handler__c   | String                           | The error handler will be called at various steps of errors/exception that occur in the consumer or the publisher                                                      |
| High Volume     | High_Volume__c     | Boolean                          | Is this a high-volume? If true, then it is common to save the incoming event in JSON and passed to the log handler                                                     |
| Log Handler     | Log_Handler__c     | String                           | The log handler will be called in the consumer or the publisher with instrumentation data                                                                              |
| Pulisher        | Pulisher__c        | String                           | The publisher to invoke. The default publisher, accc_DefaultPEPublisher, provides a consistent process for publishing. There are hooks to override behavior, if needed. |
| Success Handler | Success_Handler__c | String                           | The success handler will be called if no errors or exceptions that occur in the consumer or the publisher                                                              |
| Store Handler | Store_Handler__c | String                           | The store handler will be called to store event(s) from the consumer or the publisher                                                              |
![](media/b6d3052dd84cf4aca2162aa407f03ff9.png)

![](media/9d8475b9f42f608b02bc02ee666d3a28.png)
