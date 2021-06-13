//------------------------------------------------------------------------------------------------//
// This file is part of the Nebula Logger project, released under the MIT License.                //
// See LICENSE file or go to https://github.com/jongpie/NebulaLogger for full license details.    //
//------------------------------------------------------------------------------------------------//

/**
 * @group Plugin Framework
 * @description Abstract class used to create custom Apex plugins to execute for all trigger operations on `Log__c` or `LogEntry__c`
 */
// TODO: If possible, convert to `global` for the managed package - there are some additional platform limitations...
//      ... and restrictions with making future changes to abstract classes & interfaces within managed packages...
//      ... which could lead to a lot of problems, so for now/indefinitely, plugins will only work in the unlocked package
public abstract class LoggerSObjectHandlerPlugin {
    /**
     * @description This method is the entry point for plugins to execute any custom logic.
     *              It is automatically called by the logging system for any enabled plugins.
     *              Several trigger-based parameters are provided - these parameters should be used by plugins,
     *              instead of calling the platform's static variables directly
     *              (e.g., use the provided `triggerNew` variable instead of using `Trigger.new` directly, and so on).
     * @param  triggerOperationType The enum instance of `Trigger.operationType` at the time that the handler class is created
     * @param  triggerNew           The value `Trigger.new` at the time that the handler class is created
     * @param  triggerNewMap        The value `Trigger.newMap` at the time that the handler class is created
     * @param  triggerOld           The value `Trigger.old` at the time that the handler class is created
     * @param  triggerOldMap        The value `Trigger.oldMap` at the time that the handler class is created
     */
    public abstract void execute(
        TriggerOperation triggerOperationType,
        List<SObject> triggerNew,
        Map<Id, SObject> triggerNewMap,
        List<SObject> triggerOld,
        Map<Id, SObject> triggerOldMap
    );

    /**
     * @description Returns the configured value of the field `LoggerSObjectHandlerPluginParameter__mdt.Value__c` as a `String`
     * @param  parameterDeveloperName The developer name of the instance of `LoggerSObjectHandlerPluginParameter__mdt`
     * @return                        The `String` value configured in the matching instance of `LoggerSObjectHandlerPluginParameter__mdt`, or null if not found
     */
    protected String getStringParameter(String parameterDeveloperName) {
        return this.getParameter(parameterDeveloperName)?.Value__c;
    }

    /**
     * @description Returns the configured value of the field `LoggerSObjectHandlerPluginParameter__mdt.Value__c` as a `Boolean`
     * @param  parameterDeveloperName The developer name of the instance of `LoggerSObjectHandlerPluginParameter__mdt`
     * @return                        The `Boolean` value configured in the matching instance of `LoggerSObjectHandlerPluginParameter__mdt`, or null if not found
     */
    protected Boolean getBooleanParameter(String parameterDeveloperName) {
        return Boolean.valueOf(this.getStringParameter(parameterDeveloperName));
    }

    /**
     * @description Returns the configured value of the field `LoggerSObjectHandlerPluginParameter__mdt.Value__c` as a `Date`
     * @param  parameterDeveloperName The developer name of the instance of `LoggerSObjectHandlerPluginParameter__mdt`
     * @return                        The `Date` value configured in the matching instance of `LoggerSObjectHandlerPluginParameter__mdt`, or null if not found
     */
    protected Date getDateParameter(String parameterDeveloperName) {
        return Date.valueOf(this.getStringParameter(parameterDeveloperName));
    }

    /**
     * @description Returns the configured value of the field `LoggerSObjectHandlerPluginParameter__mdt.Value__c` as a `Datetime`
     * @param  parameterDeveloperName The developer name of the instance of `LoggerSObjectHandlerPluginParameter__mdt`
     * @return                        The `Datetime` value configured in the matching instance of `LoggerSObjectHandlerPluginParameter__mdt`, or null if not found
     */
    protected Datetime getDatetimeParameter(String parameterDeveloperName) {
        return Datetime.valueOf(this.getStringParameter(parameterDeveloperName));
    }

    /**
     * @description Returns the configured value of the field `LoggerSObjectHandlerPluginParameter__mdt.Value__c` as a `Decimal`
     * @param  parameterDeveloperName The developer name of the instance of `LoggerSObjectHandlerPluginParameter__mdt`
     * @return                        The `Decimal` value configured in the matching instance of `LoggerSObjectHandlerPluginParameter__mdt`, or null if not found
     */
    protected Decimal getDecimalParameter(String parameterDeveloperName) {
        return Decimal.valueOf(this.getStringParameter(parameterDeveloperName));
    }

    /**
     * @description Returns the configured value of the field `LoggerSObjectHandlerPluginParameter__mdt.Value__c` as a `Double`
     * @param  parameterDeveloperName The developer name of the instance of `LoggerSObjectHandlerPluginParameter__mdt`
     * @return                        The `Double` value configured in the matching instance of `LoggerSObjectHandlerPluginParameter__mdt`, or null if not found
     */
    protected Double getDoubleParameter(String parameterDeveloperName) {
        return Double.valueOf(this.getStringParameter(parameterDeveloperName));
    }

    /**
     * @description Returns the configured value of the field `LoggerSObjectHandlerPluginParameter__mdt.Value__c` as a `Id`
     * @param  parameterDeveloperName The developer name of the instance of `LoggerSObjectHandlerPluginParameter__mdt`
     * @return                        The `Id` value configured in the matching instance of `LoggerSObjectHandlerPluginParameter__mdt`, or null if not found
     */
    protected Id getIdParameter(String parameterDeveloperName) {
        return Id.valueOf(this.getStringParameter(parameterDeveloperName));
    }

    /**
     * @description Returns the configured value of the field `LoggerSObjectHandlerPluginParameter__mdt.Value__c` as a `Integer`
     * @param  parameterDeveloperName The developer name of the instance of `LoggerSObjectHandlerPluginParameter__mdt`
     * @return                        The `Integer` value configured in the matching instance of `LoggerSObjectHandlerPluginParameter__mdt`, or null if not found
     */
    protected Integer getIntegerParameter(String parameterDeveloperName) {
        return Integer.valueOf(this.getStringParameter(parameterDeveloperName));
    }

    /**
     * @description Returns the configured value of the field `LoggerSObjectHandlerPluginParameter__mdt.Value__c` as a `Long`
     * @param  parameterDeveloperName The developer name of the instance of `LoggerSObjectHandlerPluginParameter__mdt`
     * @return                        The `Long` value configured in the matching instance of `LoggerSObjectHandlerPluginParameter__mdt`, or null if not found
     */
    protected Long getLongParameter(String parameterDeveloperName) {
        return Long.valueOf(this.getStringParameter(parameterDeveloperName));
    }

    /**
     * @description Returns the configured value of the field `LoggerSObjectHandlerPluginParameter__mdt.Value__c` as an `Object`
     * @param  parameterDeveloperName The developer name of the instance of `LoggerSObjectHandlerPluginParameter__mdt`
     * @return                        The `Object` value configured in the matching instance of `LoggerSObjectHandlerPluginParameter__mdt`, or null if not found
     */
    protected Object getObjectParameter(String parameterDeveloperName) {
        return (Object) this.getStringParameter(parameterDeveloperName);
    }

    /**
     * @description Returns the configured value of the field `LoggerSObjectHandlerPluginParameter__mdt.Value__c` as a `SObject`
     * @param  parameterDeveloperName The developer name of the instance of `LoggerSObjectHandlerPluginParameter__mdt`
     * @return                        The `SObject` value configured in the matching instance of `LoggerSObjectHandlerPluginParameter__mdt`, or null if not found
     */
    protected SObject getSObjectParameter(String parameterDeveloperName) {
        return (SObject) JSON.deserialize(this.getStringParameter(parameterDeveloperName), SObject.class);
    }

    /**
     * @description Returns the matching instance of `LoggerSObjectHandlerPluginParameter__mdt`
     * @param  parameterDeveloperName The developer name of the instance of `LoggerSObjectHandlerPluginParameter__mdt`
     * @return                        The matching instance of `LoggerSObjectHandlerPluginParameter__mdt`, or null if not found
     */
    protected LoggerSObjectHandlerPluginParameter__mdt getParameter(String parameterDeveloperName) {
        LoggerSObjectHandlerPluginParameter__mdt parameter = LoggerSObjectHandlerPluginParameter__mdt.getInstance(parameterDeveloperName);

        if (parameter == null || parameter.IsEnabled__c == false) {
            return null;
        }

        return parameter;
    }
}