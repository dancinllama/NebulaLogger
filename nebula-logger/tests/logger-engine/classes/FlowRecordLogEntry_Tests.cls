//------------------------------------------------------------------------------------------------//
// This file is part of the Nebula Logger project, released under the MIT License.                //
// See LICENSE file or go to https://github.com/jongpie/NebulaLogger for full license details.    //
//------------------------------------------------------------------------------------------------//

@IsTest
private class FlowRecordLogEntry_Tests {
    static FlowRecordLogEntry createFlowRecordLogEntry() {
        FlowRecordLogEntry flowRecordEntry = new FlowRecordLogEntry();
        flowRecordEntry.flowName = 'MyFlowOrProcessBuilder';
        flowRecordEntry.message = 'my test message';
        flowRecordEntry.saveLog = false;

        return flowRecordEntry;
    }

    @IsTest
    static void it_should_save_entry_when_logging_level_met() {
        User currentUser = new User(
            Id = UserInfo.getUserId(),
            FirstName = UserInfo.getFirstName(),
            LastName = UserInfo.getLastName(),
            Username = UserInfo.getUserName()
        );

        LoggingLevel userLoggingLevel = LoggingLevel.FINEST;
        LoggingLevel flowRecordEntryLoggingLevel = LoggingLevel.DEBUG;
        System.assert(userLoggingLevel.ordinal() < flowRecordEntryLoggingLevel.ordinal());

        Test.startTest();

        Logger.getUserSettings().LoggingLevel__c = userLoggingLevel.name();
        Logger.getUserSettings().EnableSystemMessages__c = false;

        FlowRecordLogEntry flowRecordEntry = createFlowRecordLogEntry();
        flowRecordEntry.loggingLevelName = flowRecordEntryLoggingLevel.name();
        flowRecordEntry.record = currentUser;
        FlowRecordLogEntry.addFlowRecordEntries(new List<FlowRecordLogEntry>{ flowRecordEntry });

        System.assertEquals(1, Logger.getBufferSize());

        Logger.saveLog();

        Test.stopTest();

        String expectedUserJson = JSON.serializePretty(currentUser);

        LogEntry__c logEntry = [
            SELECT Id, LoggingLevel__c, Message__c, OriginType__c, OriginLocation__c, RecordId__c, RecordJson__c
            FROM LogEntry__c
            ORDER BY CreatedDate
            LIMIT 1
        ];
        System.assertEquals(flowRecordEntry.loggingLevelName, logEntry.LoggingLevel__c);
        System.assertEquals(flowRecordEntry.message, logEntry.Message__c);
        System.assertEquals('Flow', logEntry.OriginType__c);
        System.assertEquals(currentUser.Id, logEntry.RecordId__c);
        System.assertEquals(expectedUserJson, logEntry.RecordJson__c);
    }

    @IsTest
    static void it_should_auto_save_entry_when_saveLog_is_true() {
        User currentUser = new User(
            Id = UserInfo.getUserId(),
            FirstName = UserInfo.getFirstName(),
            LastName = UserInfo.getLastName(),
            Username = UserInfo.getUserName()
        );

        LoggingLevel userLoggingLevel = LoggingLevel.FINEST;
        LoggingLevel flowRecordEntryLoggingLevel = LoggingLevel.DEBUG;
        System.assert(userLoggingLevel.ordinal() < flowRecordEntryLoggingLevel.ordinal());

        Test.startTest();

        Logger.getUserSettings().LoggingLevel__c = userLoggingLevel.name();
        Logger.getUserSettings().EnableSystemMessages__c = false;

        FlowRecordLogEntry flowRecordEntry = createFlowRecordLogEntry();
        flowRecordEntry.loggingLevelName = flowRecordEntryLoggingLevel.name();
        flowRecordEntry.record = currentUser;
        flowRecordEntry.saveLog = true;
        FlowRecordLogEntry.addFlowRecordEntries(new List<FlowRecordLogEntry>{ flowRecordEntry });

        Test.stopTest();

        String expectedUserJson = JSON.serializePretty(currentUser);

        LogEntry__c logEntry = [
            SELECT Id, LoggingLevel__c, Message__c, OriginType__c, OriginLocation__c, RecordId__c, RecordJson__c
            FROM LogEntry__c
            ORDER BY CreatedDate
            LIMIT 1
        ];
        System.assertEquals(flowRecordEntry.loggingLevelName, logEntry.LoggingLevel__c);
        System.assertEquals(flowRecordEntry.message, logEntry.Message__c);
        System.assertEquals('Flow', logEntry.OriginType__c);
        System.assertEquals(currentUser.Id, logEntry.RecordId__c);
        System.assertEquals(expectedUserJson, logEntry.RecordJson__c);
    }

    @IsTest
    static void it_should_not_save_entry_when_logging_level_not_met() {
        User currentUser = new User(
            Id = UserInfo.getUserId(),
            FirstName = UserInfo.getFirstName(),
            LastName = UserInfo.getLastName(),
            Username = UserInfo.getUserName()
        );

        LoggingLevel userLoggingLevel = LoggingLevel.ERROR;
        LoggingLevel flowRecordEntryLoggingLevel = LoggingLevel.DEBUG;
        System.assert(userLoggingLevel.ordinal() > flowRecordEntryLoggingLevel.ordinal());

        Test.startTest();

        Logger.getUserSettings().LoggingLevel__c = userLoggingLevel.name();
        Logger.getUserSettings().EnableSystemMessages__c = false;

        FlowRecordLogEntry flowRecordEntry = createFlowRecordLogEntry();
        flowRecordEntry.loggingLevelName = flowRecordEntryLoggingLevel.name();
        flowRecordEntry.record = currentUser;
        FlowRecordLogEntry.addFlowRecordEntries(new List<FlowRecordLogEntry>{ flowRecordEntry });

        System.assertEquals(0, Logger.getBufferSize());

        Test.stopTest();
    }

    @IsTest
    static void it_should_use_debug_as_default_level_when_faultMessage_is_null() {
        LoggingLevel expectedEntryLoggingLevel = LoggingLevel.DEBUG;

        Test.startTest();

        Logger.getUserSettings().LoggingLevel__c = expectedEntryLoggingLevel.name();
        Logger.getUserSettings().EnableSystemMessages__c = false;

        FlowRecordLogEntry flowRecordEntry = createFlowRecordLogEntry();
        System.assertEquals(null, flowRecordEntry.faultMessage);
        System.assertEquals(null, flowRecordEntry.loggingLevelName);

        FlowRecordLogEntry.addFlowRecordEntries(new List<FlowRecordLogEntry>{ flowRecordEntry });

        System.assertEquals(1, Logger.getBufferSize());

        Logger.saveLog();

        Test.stopTest();

        LogEntry__c logEntry = [
            SELECT Id, ExceptionMessage__c, ExceptionType__c, LoggingLevel__c, Message__c, OriginType__c, OriginLocation__c, RecordId__c, RecordJson__c
            FROM LogEntry__c
            ORDER BY CreatedDate
            LIMIT 1
        ];
        System.assertEquals(null, logEntry.ExceptionMessage__c);
        System.assertEquals(null, logEntry.ExceptionType__c);
        System.assertEquals(expectedEntryLoggingLevel.name(), logEntry.LoggingLevel__c);
        System.assertEquals(flowRecordEntry.message, logEntry.Message__c);
        System.assertEquals('Flow', logEntry.OriginType__c);
    }

    @IsTest
    static void it_should_use_error_as_default_level_when_faultMessage_is_not_null() {
        LoggingLevel expectedEntryLoggingLevel = LoggingLevel.ERROR;

        Test.startTest();

        Logger.getUserSettings().LoggingLevel__c = LoggingLevel.FINEST.name();
        Logger.getUserSettings().EnableSystemMessages__c = false;

        FlowRecordLogEntry flowRecordEntry = createFlowRecordLogEntry();
        flowRecordEntry.faultMessage = 'Whoops, a Flow error has occurred.';
        System.assertEquals(null, flowRecordEntry.loggingLevelName);

        FlowRecordLogEntry.addFlowRecordEntries(new List<FlowRecordLogEntry>{ flowRecordEntry });

        System.assertEquals(1, Logger.getBufferSize());

        Logger.saveLog();

        Test.stopTest();

        LogEntry__c logEntry = [
            SELECT Id, ExceptionMessage__c, ExceptionType__c, LoggingLevel__c, Message__c, OriginType__c, OriginLocation__c, RecordId__c, RecordJson__c
            FROM LogEntry__c
            ORDER BY CreatedDate
            LIMIT 1
        ];
        System.assertEquals(flowRecordEntry.faultMessage, logEntry.ExceptionMessage__c);
        System.assertEquals('Flow.FaultError', logEntry.ExceptionType__c);
        System.assertEquals(expectedEntryLoggingLevel.name(), logEntry.LoggingLevel__c);
        System.assertEquals(flowRecordEntry.message, logEntry.Message__c);
        System.assertEquals('Flow', logEntry.OriginType__c);
    }

    @IsTest
    static void it_should_add_tags_to_log_entry() {
        LoggingLevel userLoggingLevel = LoggingLevel.FINEST;
        LoggingLevel flowRecordEntryLoggingLevel = LoggingLevel.DEBUG;
        System.assert(userLoggingLevel.ordinal() < flowRecordEntryLoggingLevel.ordinal());

        Test.startTest();

        Logger.getUserSettings().LoggingLevel__c = userLoggingLevel.name();
        Logger.getUserSettings().EnableSystemMessages__c = false;

        List<String> tags = new List<String>{ 'first tag', 'SECOND TAG' };
        FlowRecordLogEntry flowEntry = createFlowRecordLogEntry();
        flowEntry.loggingLevelName = flowRecordEntryLoggingLevel.name();
        flowEntry.tagsString = String.join(tags, ', ');
        FlowRecordLogEntry.addFlowRecordEntries(new List<FlowRecordLogEntry>{ flowEntry });

        System.assertEquals(1, Logger.getBufferSize());

        Logger.saveLog();

        Test.stopTest();

        LogEntry__c logEntry = [SELECT Id, LoggingLevel__c, Message__c, OriginType__c, OriginLocation__c FROM LogEntry__c ORDER BY CreatedDate LIMIT 1];
        System.assertEquals(flowEntry.loggingLevelName, logEntry.LoggingLevel__c);
        System.assertEquals(flowEntry.message, logEntry.Message__c);
        System.assertEquals('Flow', logEntry.OriginType__c);

        List<LogEntryTag__c> logEntryTags = [SELECT Id, LogEntry__c, Tag__c, Tag__r.Name FROM LogEntryTag__c WHERE LogEntry__c = :logEntry.Id];
        System.assertEquals(tags.size(), logEntryTags.size(), logEntryTags);
        Set<String> tagsSet = new Set<String>(tags);
        for (LogEntryTag__c logEntryTag : logEntryTags) {
            System.assert(tagsSet.contains(logEntryTag.Tag__r.Name));
        }
    }
}
