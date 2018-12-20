/**
 * Copyright (c) 2016-2018, Bill Anderson.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *
 *   * Neither the name of Bill Anderson nor the names of its
 *     contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * @author Bill Anderson
 * @description Creates default Fallback Metadata; when not found
 * @group Domain Layer
 */
public with sharing class evt_PlatformEventCmdFallback {
	/**
	 * @brief ctor
	 * @description ctor
	 *
	 */
	public evt_PlatformEventCmdFallback() {

	} // end of ctor
	/**
	 * @description create default values for custom metadata
	 * 
	 * @param eventName event name
	 * @return List<evt_Platform_Event_Binding__mdt>
	 */
	public static List<evt_Platform_Event_Binding__mdt> getFallbackMetadata(String eventName) {
		return evt_PlatformEventCmdFallback.getFallbackMetadata(eventName, evt_PlatformEvtUtilities.TEST_ENVIRONMENT);
	}
	/**
	 * @description create default values for custom metadata
	 * 
	 * @param eventName event name
	 * @param environment the running environment
	 * @return List<evt_Platform_Event_Binding__mdt>
	 */
	public static List<evt_Platform_Event_Binding__mdt> getFallbackMetadata(String eventName, string environment) {

		List<evt_Platform_Event_Binding__mdt> mdtList = new List<evt_Platform_Event_Binding__mdt>();
		evt_Platform_Event_Binding__mdt defaultMDT = new evt_Platform_Event_Binding__mdt();

		defaultMDT.Label = eventName;
		defaultMDT.NamespacePrefix = '';
		defaultMDT.DeveloperName = eventName;

		/* Set default platform event **/

		defaultMDT.Store_Handler__c = evt_PlatformEvtMdtDataModel.DefaultProcessHandlerClass;
		defaultMDT.Alert_Handler__c = evt_PlatformEvtMdtDataModel.DefaultProcessHandlerClass;
		defaultMDT.Consumer__c = evt_PlatformEvtMdtDataModel.DefaultConsumerClass;
		defaultMDT.Publisher__c = evt_PlatformEvtMdtDataModel.DefaultPublisherClass;
		defaultMDT.Environment__c = string.isBlank(environment) ? evt_PlatformEvtUtilities.TEST_ENVIRONMENT : environment;
		defaultMDT.Error_Handler__c = evt_PlatformEvtMdtDataModel.DefaultProcessHandlerClass;
		defaultMDT.Log_Handler__c = evt_PlatformEvtMdtDataModel.DefaultProcessHandlerClass;
		defaultMDT.Success_Handler__c = evt_PlatformEvtMdtDataModel.DefaultProcessHandlerClass;
		defaultMDT.Serialize_Event__c = true;
		defaultMDT.Active__c = true;
		defaultMDT.Allow_Consumer_Retry__c = true;

		mdtList.add(defaultMDT);
 
		return mdtList;
	} // end of getFallbackMetadata

} // end of evt_PlatformEventCmdFallback