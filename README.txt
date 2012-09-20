/*
//                           _  __     _ _
//                          | |/ /__ _| | |_ _  _ _ _ __ _
//                          | ' </ _` | |  _| || | '_/ _` |
//                          |_|\_\__,_|_|\__|\_,_|_| \__,_|
//
// Copyright (C) Kaltura Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

Deployment usage:
	krecord_styling > deliver > krecord.php
		Open the file (krecord.php), edit your partner details
		Place the file in your localhost (or PHP server of choice)
		Open the file in your browser
	Or use the Flash / Flex wrapper projects:
		KRecordContainerFlash
		KRecordContainerFlex

KRECORD - Flash Video and Audio Recording and Contributing Application.

Use KRecord.as application as usage example of KRecordControl Component inside a flash application.

Goals:
	1. Simplified Media Device Detection (Active Camera and Microphone).
	2. Simplified Media Selection Interface (Functions for manually choosing devices from available devices array).
	3. Server Connection and Error Handling.
	4. Video and Audio Recording on Red5, Handling of internal NetStream Events and Errors.
	5. Preview Mechanism - Live Preview using RTMP (Before addentry).
	6. Simplified addentry function to Kaltura Network Servers.
	7. Full JavaScript interaction layer.
	8. Dispatching of Events by Single Object to simplify Development of Recording Applications.
* KRecorder does NOT provide any visual elements beyond a native flash video component attached to the recording NetStream.

Usage:
	*. Use KRecordControl.as Class directly in your Flash application (Or compile KRecord.as and Embed in your JavaScript application - Not available yet).
	1. Set initialization parameters using the initRecorderParameters Setter.
	2. Call the deviceDetection Method - this will iterate through the user's installed devices
		and automatically determine the optimal Camera and Microphone devices to use.
			* After Detection is completed the following Events may dispatch:
				DeviceDetectionEvent.DETECTED_MICROPHONE - A valid microphone device was successfully detected.
				DeviceDetectionEvent.DETECTED_CAMERA - A valid Camera device was successfully detected.
				DeviceDetectionEvent.ERROR_MICROPHONE - There was an error detecting a valid microphone device (Or no microphone device found).
				DeviceDetectionEvent.ERROR_CAMERA - There was an error detecting a valid camera device (Or no camera device found).
	2. Alternatively, call getCameras / getMicrophones and use setActiveCamera or setActiveMicrophone to manually determine the devices to use.
			* After Setting the devices the following Events may dispatch:
				DeviceDetectionEvent.ERROR_MICROPHONE - The microphone device selected is fault, an error was dispatched by the flash player.
				DeviceDetectionEvent.ERROR_CAMERA - The camera device selected is fault, an error was dispatched by the flash player.
	3. Call the connectToRecordingServie Method - this will initiate a connection to the recording server.
			* After Connection Sequence is completed, the following Events may dispatch:
				ExNetConnectionEvent.NETCONNECTION_CONNECT_SUCCESS - Connection to the Recording Service was established successfully.
				ExNetConnectionEvent.NETCONNECTION_CONNECT_CLOSED - Connection to the Recording Service was Closed (This will also be dispatched after dispose).
				ExNetConnectionEvent.NETCONNECTION_CONNECT_FAILED - The Connection attempt failed (Service unavailable).
				ExNetConnectionEvent.NETCONNECTION_CONNECT_INVALIDAPP - The Recording Application is unavailable (Should only happen if application id is specifically changed).
				ExNetConnectionEvent.NETCONNECTION_CONNECT_REJECTED - The client does not have permission to connect to the Recording Service.
	4. Call the recordNewStream Method - this will initiate a new stream on the Recording Server and start publishing the user mic and cam.
			* This Method will dispatch the following Events:
				Any of the Connection Error Events can be dispatched upon a bad user connection.
				RecordNetStreamEvent.NETSTREAM_RECORD_START - When RecordNewStream Method is called, the application will initialize a new stream,
																this requires a request and response from the server. When a success response is returned,
																the application begins the actual recording and dispatches this event.
	5. Call the stopRecording Method - this will end the recording and send the server a request to send the remaining of the recording buffer to the server and close the stream.
			* After StopRecording Method is called, the following Events may dispatch:
				FlushStreamEvent.FLUSH_START - The server response was received, the remaining of the recording buffer is being sent.
				FlushStreamEvent.FLUSH_PROGRESS - The remaining of the recording buffer is being sent, this Event notify of its progress.
				FlushStreamEvent.FLUSH_COMPLETE - The remaining of the recording buffer is fully sent to the server and flushed to stream. Now it is safe to preview or addentry.
	6. Call the previewRecording Method - this will playback the video / audio recorded.
			* The following Events may dispatch:
				RecordNetStreamEvent.NETSTREAM_PLAY_STOP - Playback has finished.
	7. Call the stopPreviewRecording Method - this will stop the preview.
			* The following Events may dispatch:
				RecordNetStreamEvent.NETSTREAM_PLAY_STOP - Playback has finished.
	8. Call the addEntry Method providing information about the Recording (e.g. title, tags...) to add the new recording as a Kaltura Entry.
			* The following Events will dispatch:
				AddEntryEvent.ADD_ENTRY_RESULT - Notify about a successful addentry Method, and provides the new entryId of the recording.
												This Event contains a KalturaEntry Object that holds the info of the newly created entry.
				AddEntryEvent.ADD_ENTRY_FAULT - An error has occur while trying to add the new recording as Kaltura Entry.

All Events/Methods are handled in JavaScript in the lowerCamelCase form of their Event/Method name.

Public Properties:
	isConnected - indicates if the KRecorder is connected to the Streaming Server.
	streamUid - the file name of the recording data being recorded on the server.
	recordedTime - the duration of the last recording.
	blackRecordTime - the duration of the black delay between publish request and start_record response.
	micophoneActivityLevel - activity level of the active microphone device, can be used to simulate detected volume level.

Public Methods:
	stopRecording - stop recording the camera.
	startRecording - start recording and sending stream to server.
	previewRecording - preveiw the recorded stream.
	getRecordedTime - returns the length in time of the recording.
	addEntry - calls the addentry service to create a new entry on the kaltura server.
	setQuality - change the quality of the recorded stream.
	openSettings- Force to open the Flash Security Panel for Microphone settings
	
	Notifications to Java script call backs:
	workingMicFound: working mic found by the app.
	notMicsFound: Not able microphone was found.
	micDenied: The user denied the access to the mic through the Security Panel
	
	
	Flash Vars:
	timeLapse: time in milliseconds allowed for checking the next microphone. Default is 20000
	