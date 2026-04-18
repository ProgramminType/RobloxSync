--[=[
  Roblox Sync Plugin v1.5.0
  Auto-generated — do not edit directly.
  Edit the source files in roblox-plugin/src/ instead.
]=]

local _modules = {}
local _loaded = {}

local function _require(name)
  if _loaded[name] then
    return _loaded[name]
  end
  local loader = _modules[name]
  if not loader then
    error("Module not found: " .. name)
  end
  _loaded[name] = loader()
  return _loaded[name]
end

_modules["PropertyDatabase"] = function()
local db = {}
db["Object"]={super="<<<ROOT>>>",props={}}
db["AnimationNode"]={super="Object",props={}}
db["AuroraHandle"]={super="Object",props={}}
db["Capture"]={super="Object",props={}}
db["ScreenshotCapture"]={super="Capture",props={}}
db["VideoCapture"]={super="Capture",props={}}
db["ConfigSnapshot"]={super="Object",props={}}
db["EditableImage"]={super="Object",props={}}
db["EditableMesh"]={super="Object",props={}}
db["ExecutedRemoteCommand"]={super="Object",props={}}
db["Instance"]={super="Object",props={"Capabilities","Name","Sandboxed"}}
db["AccessoryDescription"]={super="Instance",props={"AccessoryType","AssetId","IsLayered","Order","Position","Puffiness","Rotation","Scale"}}
db["AccountService"]={super="Instance",props={}}
db["Accoutrement"]={super="Instance",props={"AttachmentPoint"}}
db["Accessory"]={super="Accoutrement",props={"AccessoryType"}}
db["Hat"]={super="Accoutrement",props={}}
db["AchievementService"]={super="Instance",props={}}
db["ActivityHistoryEventService"]={super="Instance",props={}}
db["AdPortal"]={super="Instance",props={}}
db["AdService"]={super="Instance",props={}}
db["AdvancedDragger"]={super="Instance",props={}}
db["AnalyticsService"]={super="Instance",props={}}
db["Animation"]={super="Instance",props={"AnimationId"}}
db["AnimationClip"]={super="Instance",props={"Loop","Priority"}}
db["AnimationGraphDefinition"]={super="AnimationClip",props={}}
db["CurveAnimation"]={super="AnimationClip",props={}}
db["KeyframeSequence"]={super="AnimationClip",props={}}
db["AnimationClipProvider"]={super="Instance",props={}}
db["AnimationController"]={super="Instance",props={}}
db["AnimationFromVideoCreatorService"]={super="Instance",props={}}
db["AnimationFromVideoCreatorStudioService"]={super="Instance",props={}}
db["AnimationNodeDefinition"]={super="Instance",props={"NodeType"}}
db["AnimationRigData"]={super="Instance",props={}}
db["AnimationStreamTrack"]={super="Instance",props={}}
db["AnimationTrack"]={super="Instance",props={"Looped","Priority","TimePosition"}}
db["Animator"]={super="Instance",props={"PreferLodEnabled"}}
db["Annotation"]={super="Instance",props={}}
db["WorkspaceAnnotation"]={super="Annotation",props={}}
db["AnnotationsService"]={super="Instance",props={}}
db["AppAgeSignalsService"]={super="Instance",props={}}
db["AppLifecycleObserverService"]={super="Instance",props={}}
db["AppRatingPromptService"]={super="Instance",props={}}
db["AppUpdateService"]={super="Instance",props={}}
db["AssetCounterService"]={super="Instance",props={}}
db["AssetDeliveryProxy"]={super="Instance",props={"Interface","Port","StartServer"}}
db["AssetImportService"]={super="Instance",props={}}
db["AssetManagerService"]={super="Instance",props={}}
db["AssetPatchSettings"]={super="Instance",props={"ContentId","OutputPath","PatchId"}}
db["AssetQualityService"]={super="Instance",props={}}
db["AssetService"]={super="Instance",props={}}
db["Atmosphere"]={super="Instance",props={"Color","Decay","Density","Glare","Haze","Offset"}}
db["Attachment"]={super="Instance",props={"Axis","CFrame","SecondaryAxis","Visible","WorldAxis","WorldCFrame","WorldSecondaryAxis"}}
db["Bone"]={super="Attachment",props={"Transform"}}
db["AudioAnalyzer"]={super="Instance",props={"SpectrumEnabled","WindowSize"}}
db["AudioChannelMixer"]={super="Instance",props={"Layout"}}
db["AudioChannelSplitter"]={super="Instance",props={"Layout"}}
db["AudioChorus"]={super="Instance",props={"Bypass","Depth","Mix","Rate"}}
db["AudioCompressor"]={super="Instance",props={"Attack","Bypass","MakeupGain","Ratio","Release","Threshold"}}
db["AudioDeviceInput"]={super="Instance",props={"AccessType","Muted","Volume"}}
db["AudioDeviceOutput"]={super="Instance",props={}}
db["AudioDistortion"]={super="Instance",props={"Bypass","Level"}}
db["AudioEcho"]={super="Instance",props={"Bypass","DelayTime","DryLevel","Feedback","RampTime","WetLevel"}}
db["AudioEmitter"]={super="Instance",props={"AcousticSimulationEnabled","AudioInteractionGroup"}}
db["AudioEqualizer"]={super="Instance",props={"Bypass","HighGain","LowGain","MidGain","MidRange"}}
db["AudioFader"]={super="Instance",props={"Bypass","Volume"}}
db["AudioFilter"]={super="Instance",props={"Bypass","FilterType","Frequency","Gain","Q"}}
db["AudioFlanger"]={super="Instance",props={"Bypass","Depth","Mix","Rate"}}
db["AudioFocusService"]={super="Instance",props={}}
db["AudioGate"]={super="Instance",props={"Attack","Bypass","Release","Threshold"}}
db["AudioLimiter"]={super="Instance",props={"Bypass","MaxLevel","Release"}}
db["AudioListener"]={super="Instance",props={"AcousticSimulationEnabled","AudioInteractionGroup"}}
db["AudioPitchShifter"]={super="Instance",props={"Bypass","Pitch","WindowSize"}}
db["AudioPlayer"]={super="Instance",props={"Asset","AutoLoad","AutoPlay","LoopRegion","Looping","PlaybackRegion","PlaybackSpeed","TimePosition","Volume"}}
db["AudioRecorder"]={super="Instance",props={}}
db["AudioReverb"]={super="Instance",props={"Bypass","DecayRatio","DecayTime","Density","Diffusion","DryLevel","EarlyDelayTime","HighCutFrequency","LateDelayTime","LowShelfFrequency","LowShelfGain","ReferenceFrequency","WetLevel"}}
db["AudioSearchParams"]={super="Instance",props={"Album","Artist","AudioSubType","MaxDuration","MinDuration","SearchKeyword","Tag","Title"}}
db["AudioSpeechToText"]={super="Instance",props={"Enabled","Text"}}
db["AudioTextToSpeech"]={super="Instance",props={"Looping","Pitch","PlaybackSpeed","Speed","Text","TimePosition","VoiceId","Volume"}}
db["AudioTremolo"]={super="Instance",props={"Bypass","Depth","Duty","Frequency","Shape","Skew","Square"}}
db["AuroraScriptObject"]={super="Instance",props={"FrameId","LODLevel","PriorFrameInvoked"}}
db["AuroraScriptService"]={super="Instance",props={}}
db["AuroraService"]={super="Instance",props={"HashRoundingPoint","IgnoreRotation","LockStepIdOffset","RollbackOffset"}}
db["AvatarAbilityRules"]={super="Instance",props={}}
db["AvatarAccessoryRules"]={super="Instance",props={}}
db["AvatarAnimationRules"]={super="Instance",props={}}
db["AvatarBodyRules"]={super="Instance",props={}}
db["AvatarChatService"]={super="Instance",props={}}
db["AvatarClothingRules"]={super="Instance",props={}}
db["AvatarCollisionRules"]={super="Instance",props={}}
db["AvatarCreationService"]={super="Instance",props={}}
db["AvatarEditorService"]={super="Instance",props={}}
db["AvatarImportService"]={super="Instance",props={}}
db["AvatarRules"]={super="Instance",props={}}
db["AvatarSettings"]={super="Instance",props={}}
db["Backpack"]={super="Instance",props={}}
db["BadgeService"]={super="Instance",props={}}
db["BaseCoreGuiConfiguration"]={super="Instance",props={"Enabled"}}
db["CapturesViewConfiguration"]={super="BaseCoreGuiConfiguration",props={"Open"}}
db["PlayerListConfiguration"]={super="BaseCoreGuiConfiguration",props={"Open"}}
db["SelfViewConfiguration"]={super="BaseCoreGuiConfiguration",props={"Open"}}
db["BaseImportData"]={super="Instance",props={"ImportName","ShouldImport"}}
db["AnimationImportData"]={super="BaseImportData",props={}}
db["FacsImportData"]={super="BaseImportData",props={}}
db["GroupImportData"]={super="BaseImportData",props={"Anchored","ImportAsModelAsset","InsertInWorkspace"}}
db["JointImportData"]={super="BaseImportData",props={}}
db["MaterialImportData"]={super="BaseImportData",props={"DiffuseFilePath","EmissiveFilePath","MetalnessFilePath","NormalFilePath","RoughnessFilePath"}}
db["MeshImportData"]={super="BaseImportData",props={"Anchored","CageMeshIntersectedPreview","CageNonManifoldPreview","CageOverlappingVerticesPreview","CageUVMisMatchedPreview","DoubleSided","IgnoreVertexColors","IrrelevantCageModifiedPreview","MeshHoleDetectedPreview","OuterCageFarExtendedFromMeshPreview","UseImportedPivot"}}
db["RootImportData"]={super="BaseImportData",props={"AddModelToInventory","Anchored","AnimationIdForRestPose","ExistingPackageId","ImportAsModelAsset","ImportAsPackage","InsertInWorkspace","InsertWithScenePosition","InvertNegativeFaces","KeepZeroInfluenceBones","MergeMeshes","PreferredUploadId","RestPose","RigScale","RigType","RigVisualization","ScaleUnit","UseSceneOriginAsPivot","UsesCages","ValidateUgcBody","WorldForward","WorldUp"}}
db["BasePlayerGui"]={super="Instance",props={}}
db["CoreGui"]={super="BasePlayerGui",props={}}
db["PlayerGui"]={super="BasePlayerGui",props={"ScreenOrientation"}}
db["StarterGui"]={super="BasePlayerGui",props={"ScreenOrientation","ShowDevelopmentGui"}}
db["BaseRemoteEvent"]={super="Instance",props={}}
db["RemoteEvent"]={super="BaseRemoteEvent",props={}}
db["UnreliableRemoteEvent"]={super="BaseRemoteEvent",props={}}
db["BaseWrap"]={super="Instance",props={}}
db["WrapDeformer"]={super="BaseWrap",props={}}
db["WrapLayer"]={super="BaseWrap",props={"AutoSkin","Enabled","Order","Puffiness"}}
db["WrapTarget"]={super="BaseWrap",props={}}
db["Beam"]={super="Instance",props={"Brightness","Color","CurveSize0","CurveSize1","Enabled","FaceCamera","LightEmission","LightInfluence","Segments","Texture","TextureLength","TextureMode","TextureSpeed","Transparency","Width0","Width1","ZOffset"}}
db["BindableEvent"]={super="Instance",props={}}
db["BindableFunction"]={super="Instance",props={}}
db["BodyMover"]={super="Instance",props={}}
db["BodyAngularVelocity"]={super="BodyMover",props={"AngularVelocity","MaxTorque","P"}}
db["BodyForce"]={super="BodyMover",props={"Force"}}
db["BodyGyro"]={super="BodyMover",props={"CFrame","D","MaxTorque","P"}}
db["BodyPosition"]={super="BodyMover",props={"D","MaxForce","P","Position"}}
db["BodyThrust"]={super="BodyMover",props={"Force","Location"}}
db["BodyVelocity"]={super="BodyMover",props={"MaxForce","P","Velocity"}}
db["RocketPropulsion"]={super="BodyMover",props={"CartoonFactor","MaxSpeed","MaxThrust","MaxTorque","TargetOffset","TargetRadius","ThrustD","ThrustP","TurnD","TurnP"}}
db["BodyPartDescription"]={super="Instance",props={"AssetId","BodyPart","Color","HeadShape"}}
db["Breakpoint"]={super="Instance",props={}}
db["BrowserService"]={super="Instance",props={}}
db["BugReporterService"]={super="Instance",props={}}
db["BulkImportService"]={super="Instance",props={}}
db["CacheableContentProvider"]={super="Instance",props={}}
db["HSRDataContentProvider"]={super="CacheableContentProvider",props={}}
db["MeshContentProvider"]={super="CacheableContentProvider",props={}}
db["SlimContentProvider"]={super="CacheableContentProvider",props={}}
db["SolidModelContentProvider"]={super="CacheableContentProvider",props={}}
db["CalloutService"]={super="Instance",props={}}
db["CaptureService"]={super="Instance",props={}}
db["ChangeHistoryService"]={super="Instance",props={}}
db["ChangeHistoryStreamingService"]={super="Instance",props={}}
db["CharacterAppearance"]={super="Instance",props={}}
db["BodyColors"]={super="CharacterAppearance",props={"HeadColor","HeadColor3","LeftArmColor","LeftArmColor3","LeftLegColor","LeftLegColor3","RightArmColor","RightArmColor3","RightLegColor","RightLegColor3","TorsoColor","TorsoColor3"}}
db["CharacterMesh"]={super="CharacterAppearance",props={"BaseTextureId","BodyPart","MeshId","OverlayTextureId"}}
db["Clothing"]={super="CharacterAppearance",props={"Color3"}}
db["Pants"]={super="Clothing",props={"PantsTemplate"}}
db["Shirt"]={super="Clothing",props={"ShirtTemplate"}}
db["ShirtGraphic"]={super="CharacterAppearance",props={"Color3","Graphic"}}
db["Skin"]={super="CharacterAppearance",props={"SkinColor"}}
db["Chat"]={super="Instance",props={"BubbleChatEnabled"}}
db["ClickDetector"]={super="Instance",props={"CursorIcon","MaxActivationDistance"}}
db["DragDetector"]={super="ClickDetector",props={"ActivatedCursorIcon","ApplyAtCenterOfMass","Axis","DragFrame","DragStyle","Enabled","GamepadModeSwitchKeyCode","KeyboardModeSwitchKeyCode","MaxDragAngle","MaxDragTranslation","MaxForce","MaxTorque","MinDragAngle","MinDragTranslation","Orientation","PermissionPolicy","ResponseStyle","Responsiveness","RunLocally","SecondaryAxis","TrackballRadialPullFactor","TrackballRollFactor","VRSwitchKeyCode","WorldAxis","WorldSecondaryAxis"}}
db["CloudCRUDService"]={super="Instance",props={}}
db["Clouds"]={super="Instance",props={"Color","Cover","Density","Enabled"}}
db["ClusterPacketCache"]={super="Instance",props={}}
db["Collaborator"]={super="Instance",props={}}
db["CollaboratorsService"]={super="Instance",props={}}
db["CollectionService"]={super="Instance",props={}}
db["CommerceService"]={super="Instance",props={}}
db["CompositeValueCurve"]={super="Instance",props={"CurveType"}}
db["ConfigService"]={super="Instance",props={}}
db["Configuration"]={super="Instance",props={}}
db["ConfigureServerService"]={super="Instance",props={}}
db["ConnectivityService"]={super="Instance",props={}}
db["Constraint"]={super="Instance",props={"Color","Enabled","Visible"}}
db["AlignOrientation"]={super="Constraint",props={"AlignType","CFrame","LookAtPosition","MaxAngularVelocity","MaxTorque","Mode","PrimaryAxis","PrimaryAxisOnly","ReactionTorqueEnabled","Responsiveness","RigidityEnabled","SecondaryAxis"}}
db["AlignPosition"]={super="Constraint",props={"ApplyAtCenterOfMass","ForceLimitMode","ForceRelativeTo","MaxAxesForce","MaxForce","MaxVelocity","Mode","Position","ReactionForceEnabled","Responsiveness","RigidityEnabled"}}
db["AngularVelocity"]={super="Constraint",props={"AngularVelocity","MaxTorque","ReactionTorqueEnabled","RelativeTo"}}
db["AnimationConstraint"]={super="Constraint",props={"IsKinematic","MaxForce","MaxTorque","Transform"}}
db["BallSocketConstraint"]={super="Constraint",props={"LimitsEnabled","MaxFrictionTorque","Radius","Restitution","TwistLimitsEnabled","TwistLowerAngle","TwistUpperAngle","UpperAngle"}}
db["HingeConstraint"]={super="Constraint",props={"ActuatorType","AngularResponsiveness","AngularSpeed","AngularVelocity","LimitsEnabled","LowerAngle","MotorMaxAcceleration","MotorMaxTorque","Radius","Restitution","ServoMaxTorque","TargetAngle","UpperAngle"}}
db["LineForce"]={super="Constraint",props={"ApplyAtCenterOfMass","InverseSquareLaw","Magnitude","MaxForce","ReactionForceEnabled"}}
db["LinearVelocity"]={super="Constraint",props={"ForceLimitMode","ForceLimitsEnabled","LineDirection","LineVelocity","MaxAxesForce","MaxForce","MaxPlanarAxesForce","PlaneVelocity","PrimaryTangentAxis","ReactionForceEnabled","RelativeTo","SecondaryTangentAxis","VectorVelocity","VelocityConstraintMode"}}
db["PlaneConstraint"]={super="Constraint",props={}}
db["Plane"]={super="PlaneConstraint",props={}}
db["RigidConstraint"]={super="Constraint",props={}}
db["RodConstraint"]={super="Constraint",props={"Length","LimitAngle0","LimitAngle1","LimitsEnabled","Thickness"}}
db["RopeConstraint"]={super="Constraint",props={"Length","Restitution","Thickness","WinchEnabled","WinchForce","WinchResponsiveness","WinchSpeed","WinchTarget"}}
db["SlidingBallConstraint"]={super="Constraint",props={"ActuatorType","LimitsEnabled","LinearResponsiveness","LowerLimit","MotorMaxAcceleration","MotorMaxForce","Restitution","ServoMaxForce","Size","Speed","TargetPosition","UpperLimit","Velocity"}}
db["CylindricalConstraint"]={super="SlidingBallConstraint",props={"AngularActuatorType","AngularLimitsEnabled","AngularResponsiveness","AngularRestitution","AngularSpeed","AngularVelocity","InclinationAngle","LowerAngle","MotorMaxAngularAcceleration","MotorMaxTorque","RotationAxisVisible","ServoMaxTorque","TargetAngle","UpperAngle"}}
db["PrismaticConstraint"]={super="SlidingBallConstraint",props={}}
db["SpringConstraint"]={super="Constraint",props={"Coils","Damping","FreeLength","LimitsEnabled","MaxForce","MaxLength","MinLength","Radius","Stiffness","Thickness"}}
db["Torque"]={super="Constraint",props={"RelativeTo","Torque"}}
db["TorsionSpringConstraint"]={super="Constraint",props={"Coils","Damping","LimitsEnabled","MaxAngle","MaxTorque","Radius","Restitution","Stiffness"}}
db["UniversalConstraint"]={super="Constraint",props={"LimitsEnabled","MaxAngle","Radius","Restitution"}}
db["VectorForce"]={super="Constraint",props={"ApplyAtCenterOfMass","Force","RelativeTo"}}
db["ContentProvider"]={super="Instance",props={}}
db["ContextActionService"]={super="Instance",props={}}
db["Controller"]={super="Instance",props={}}
db["HumanoidController"]={super="Controller",props={}}
db["SkateboardController"]={super="Controller",props={}}
db["VehicleController"]={super="Controller",props={}}
db["ControllerBase"]={super="Instance",props={"BalanceRigidityEnabled","MoveSpeedFactor"}}
db["AirController"]={super="ControllerBase",props={"BalanceMaxTorque","BalanceSpeed","MaintainAngularMomentum","MaintainLinearMomentum","MoveMaxForce","TurnMaxTorque","TurnSpeedFactor"}}
db["ClimbController"]={super="ControllerBase",props={"AccelerationTime","BalanceMaxTorque","BalanceSpeed","MoveMaxForce"}}
db["GroundController"]={super="ControllerBase",props={"AccelerationLean","AccelerationTime","BalanceMaxTorque","BalanceSpeed","DecelerationTime","Friction","FrictionWeight","GroundOffset","StandForce","StandSpeed","TurnSpeedFactor"}}
db["SwimController"]={super="ControllerBase",props={"AccelerationTime","PitchMaxTorque","PitchSpeedFactor","RollMaxTorque","RollSpeedFactor"}}
db["ControllerManager"]={super="Instance",props={"BaseMoveSpeed","BaseTurnSpeed","FacingDirection","MovingDirection","UpDirection"}}
db["ControllerService"]={super="Instance",props={}}
db["ConversationalAIAcceptanceService"]={super="Instance",props={}}
db["CookiesService"]={super="Instance",props={}}
db["CoreGuiConfiguration"]={super="Instance",props={}}
db["CorePackages"]={super="Instance",props={}}
db["CoreScriptDebuggingManagerHelper"]={super="Instance",props={}}
db["CoreScriptSyncService"]={super="Instance",props={}}
db["CreationDBService"]={super="Instance",props={}}
db["CreatorStoreService"]={super="Instance",props={}}
db["CrossDMScriptChangeListener"]={super="Instance",props={}}
db["CustomEvent"]={super="Instance",props={}}
db["CustomEventReceiver"]={super="Instance",props={}}
db["CustomLog"]={super="Instance",props={}}
db["DataModelMesh"]={super="Instance",props={"Offset","Scale","VertexColor"}}
db["BevelMesh"]={super="DataModelMesh",props={}}
db["BlockMesh"]={super="BevelMesh",props={}}
db["CylinderMesh"]={super="BevelMesh",props={}}
db["FileMesh"]={super="DataModelMesh",props={"MeshId","TextureId"}}
db["SpecialMesh"]={super="FileMesh",props={"MeshType"}}
db["DataModelPatchService"]={super="Instance",props={}}
db["DataModelSession"]={super="Instance",props={}}
db["DataStoreGetOptions"]={super="Instance",props={"UseCache"}}
db["DataStoreIncrementOptions"]={super="Instance",props={}}
db["DataStoreInfo"]={super="Instance",props={}}
db["DataStoreKey"]={super="Instance",props={}}
db["DataStoreKeyInfo"]={super="Instance",props={}}
db["DataStoreObjectVersionInfo"]={super="Instance",props={}}
db["DataStoreOptions"]={super="Instance",props={"AllScopes"}}
db["DataStoreService"]={super="Instance",props={}}
db["DataStoreSetOptions"]={super="Instance",props={}}
db["Debris"]={super="Instance",props={}}
db["DebugSettings"]={super="Instance",props={}}
db["DebuggablePluginWatcher"]={super="Instance",props={}}
db["DebuggerBreakpoint"]={super="Instance",props={"Condition","ContinueExecution","IsEnabled","LogExpression","isContextDependentBreakpoint"}}
db["DebuggerConnection"]={super="Instance",props={}}
db["LocalDebuggerConnection"]={super="DebuggerConnection",props={}}
db["DebuggerConnectionManager"]={super="Instance",props={}}
db["DebuggerLuaResponse"]={super="Instance",props={}}
db["DebuggerManager"]={super="Instance",props={}}
db["DebuggerUIService"]={super="Instance",props={}}
db["DebuggerVariable"]={super="Instance",props={}}
db["DebuggerWatch"]={super="Instance",props={"Expression"}}
db["DeviceIdService"]={super="Instance",props={}}
db["Dialog"]={super="Instance",props={"BehaviorType","ConversationDistance","GoodbyeChoiceActive","GoodbyeDialog","InUse","InitialPrompt","Purpose","Tone","TriggerDistance","TriggerOffset"}}
db["DialogChoice"]={super="Instance",props={"GoodbyeChoiceActive","GoodbyeDialog","ResponseDialog","UserDialog"}}
db["DigitsRigDescription"]={super="Instance",props={"Index1TposeAdjustment","Index2TposeAdjustment","Index3TposeAdjustment","IndexRange","IndexSize","Middle1TposeAdjustment","Middle2TposeAdjustment","Middle3TposeAdjustment","MiddleRange","MiddleSize","Pinky1TposeAdjustment","Pinky2TposeAdjustment","Pinky3TposeAdjustment","PinkyRange","PinkySize","Ring1TposeAdjustment","Ring2TposeAdjustment","Ring3TposeAdjustment","RingRange","RingSize","Side","Thumb1TposeAdjustment","Thumb2TposeAdjustment","Thumb3TposeAdjustment","ThumbRange","ThumbSize"}}
db["DraftsService"]={super="Instance",props={}}
db["Dragger"]={super="Instance",props={}}
db["DraggerService"]={super="Instance",props={"AlignDraggedObjects","AngleSnapEnabled","AngleSnapIncrement","AnimateHover","CollisionsEnabled","DraggerCoordinateSpace","DraggerMovementMode","GeometrySnapColor","HoverAnimateFrequency","HoverThickness","JointsEnabled","LinearSnapEnabled","LinearSnapIncrement","ShowHover","ShowPivotIndicator"}}
db["EditableService"]={super="Instance",props={}}
db["EncodingService"]={super="Instance",props={}}
db["EulerRotationCurve"]={super="Instance",props={"RotationOrder"}}
db["EventIngestService"]={super="Instance",props={}}
db["ExampleV2Service"]={super="Instance",props={}}
db["ExperienceAuthService"]={super="Instance",props={}}
db["ExperienceInviteOptions"]={super="Instance",props={"InviteMessageId","InviteUser","LaunchData","PromptMessage"}}
db["ExperienceNotificationService"]={super="Instance",props={}}
db["ExperienceService"]={super="Instance",props={}}
db["ExperienceStateCaptureService"]={super="Instance",props={}}
db["ExperienceStateRecordingService"]={super="Instance",props={}}
db["ExplorerFilter"]={super="Instance",props={}}
db["ExplorerFilterAutocompleter"]={super="Instance",props={}}
db["ExplorerServiceVisibilityService"]={super="Instance",props={}}
db["Explosion"]={super="Instance",props={"BlastPressure","BlastRadius","DestroyJointRadiusPercent","ExplosionType","Position","TimeScale","Visible"}}
db["FaceAnimatorService"]={super="Instance",props={}}
db["FaceControls"]={super="Instance",props={}}
db["FaceInstance"]={super="Instance",props={"Face"}}
db["Decal"]={super="FaceInstance",props={"Color3","ColorMap","Rotation","Texture","Transparency","UVOffset","UVScale","ZIndex"}}
db["Texture"]={super="Decal",props={"OffsetStudsU","OffsetStudsV","StudsPerTileU","StudsPerTileV"}}
db["FacialAgeEstimationService"]={super="Instance",props={}}
db["FacialAnimationRecordingService"]={super="Instance",props={}}
db["FacialAnimationStreamingServiceStats"]={super="Instance",props={}}
db["FacialAnimationStreamingServiceV2"]={super="Instance",props={}}
db["FacialAnimationStreamingSubsessionStats"]={super="Instance",props={}}
db["Feature"]={super="Instance",props={"FaceId","InOut","LeftRight","TopBottom"}}
db["Hole"]={super="Feature",props={}}
db["MotorFeature"]={super="Feature",props={}}
db["FeatureRestrictionManager"]={super="Instance",props={}}
db["File"]={super="Instance",props={}}
db["FileManagerService"]={super="Instance",props={}}
db["Fire"]={super="Instance",props={"Color","Enabled","Heat","SecondaryColor","Size","TimeScale"}}
db["FlagStandService"]={super="Instance",props={}}
db["FloatCurve"]={super="Instance",props={}}
db["FlyweightService"]={super="Instance",props={}}
db["CSGDictionaryService"]={super="FlyweightService",props={}}
db["NonReplicatedCSGDictionaryService"]={super="FlyweightService",props={}}
db["Folder"]={super="Instance",props={}}
db["ForceField"]={super="Instance",props={"Visible"}}
db["FriendService"]={super="Instance",props={}}
db["FunctionalTest"]={super="Instance",props={"Description"}}
db["GamePassService"]={super="Instance",props={}}
db["GameSettings"]={super="Instance",props={}}
db["GamepadService"]={super="Instance",props={}}
db["GenerationService"]={super="Instance",props={}}
db["GenericChallengeService"]={super="Instance",props={}}
db["Geometry"]={super="Instance",props={}}
db["GeometryService"]={super="Instance",props={}}
db["GetTextBoundsParams"]={super="Instance",props={"Font","RichText","Size","Text","Width"}}
db["GlobalDataStore"]={super="Instance",props={}}
db["DataStore"]={super="GlobalDataStore",props={}}
db["OrderedDataStore"]={super="GlobalDataStore",props={}}
db["GongService"]={super="Instance",props={}}
db["GroupService"]={super="Instance",props={}}
db["GuiBase"]={super="Instance",props={}}
db["GuiBase2d"]={super="GuiBase",props={"AutoLocalize","SelectionBehaviorDown","SelectionBehaviorLeft","SelectionBehaviorRight","SelectionBehaviorUp","SelectionGroup"}}
db["GuiObject"]={super="GuiBase2d",props={"Active","AnchorPoint","AutomaticSize","BackgroundColor3","BackgroundTransparency","BorderColor3","BorderMode","BorderSizePixel","ClipsDescendants","InputSink","Interactable","LayoutOrder","Position","Rotation","Selectable","SelectionOrder","Size","SizeConstraint","Visible","ZIndex"}}
db["CanvasGroup"]={super="GuiObject",props={"GroupColor3","GroupTransparency"}}
db["Frame"]={super="GuiObject",props={"Style"}}
db["GuiButton"]={super="GuiObject",props={"AutoButtonColor","Modal","Selected","Style"}}
db["ImageButton"]={super="GuiButton",props={"HoverImage","Image","ImageColor3","ImageRectOffset","ImageRectSize","ImageTransparency","PressedImage","ResampleMode","ScaleType","SliceCenter","SliceScale","TileSize"}}
db["TextButton"]={super="GuiButton",props={"FontFace","LineHeight","MaxVisibleGraphemes","OpenTypeFeatures","RichText","Text","TextColor3","TextDirection","TextScaled","TextSize","TextStrokeColor3","TextStrokeTransparency","TextTransparency","TextTruncate","TextWrapped","TextXAlignment","TextYAlignment"}}
db["GuiLabel"]={super="GuiObject",props={}}
db["ImageLabel"]={super="GuiLabel",props={"Image","ImageColor3","ImageRectOffset","ImageRectSize","ImageTransparency","ResampleMode","ScaleType","SliceCenter","SliceScale","TileSize"}}
db["TextLabel"]={super="GuiLabel",props={"FontFace","LineHeight","MaxVisibleGraphemes","OpenTypeFeatures","RichText","Text","TextColor3","TextDirection","TextScaled","TextSize","TextStrokeColor3","TextStrokeTransparency","TextTransparency","TextTruncate","TextWrapped","TextXAlignment","TextYAlignment"}}
db["RelativeGui"]={super="GuiObject",props={}}
db["ScrollingFrame"]={super="GuiObject",props={"AutomaticCanvasSize","BottomImage","CanvasPosition","CanvasSize","ElasticBehavior","HorizontalScrollBarInset","MidImage","ScrollBarImageColor3","ScrollBarImageTransparency","ScrollBarThickness","ScrollingDirection","ScrollingEnabled","TopImage","VerticalScrollBarInset","VerticalScrollBarPosition"}}
db["TextBox"]={super="GuiObject",props={"ClearTextOnFocus","CursorPosition","FontFace","LineHeight","MaxVisibleGraphemes","MultiLine","OpenTypeFeatures","PlaceholderColor3","PlaceholderText","RichText","SelectionStart","ShowNativeInput","Text","TextColor3","TextDirection","TextEditable","TextScaled","TextSize","TextStrokeColor3","TextStrokeTransparency","TextTransparency","TextTruncate","TextWrapped","TextXAlignment","TextYAlignment"}}
db["VideoDisplay"]={super="GuiObject",props={"ResampleMode","ScaleType","TileSize","VideoColor3","VideoRectOffset","VideoRectSize","VideoTransparency"}}
db["VideoFrame"]={super="GuiObject",props={"Looped","Playing","TimePosition","Video","Volume"}}
db["ViewportFrame"]={super="GuiObject",props={"Ambient","ImageColor3","ImageTransparency","LightColor","LightDirection"}}
db["LayerCollector"]={super="GuiBase2d",props={"Enabled","ResetOnSpawn","ZIndexBehavior"}}
db["BillboardGui"]={super="LayerCollector",props={"Active","AlwaysOnTop","Brightness","ClipsDescendants","DistanceStep","ExtentsOffset","ExtentsOffsetWorldSpace","LightInfluence","MaxDistance","Size","SizeOffset","StudsOffset","StudsOffsetWorldSpace"}}
db["PluginGui"]={super="LayerCollector",props={"Title"}}
db["DockWidgetPluginGui"]={super="PluginGui",props={}}
db["QWidgetPluginGui"]={super="PluginGui",props={}}
db["ScreenGui"]={super="LayerCollector",props={"ClipToDeviceSafeArea","DisplayOrder","IgnoreGuiInset","SafeAreaCompatibility","ScreenInsets"}}
db["GuiMain"]={super="ScreenGui",props={}}
db["SurfaceGuiBase"]={super="LayerCollector",props={"Active","Face"}}
db["AdGui"]={super="SurfaceGuiBase",props={"AdShape","EnableVideoAds","FallbackImage"}}
db["SurfaceGui"]={super="SurfaceGuiBase",props={"AlwaysOnTop","Brightness","CanvasSize","ClipsDescendants","LightInfluence","MaxDistance","PixelsPerStud","SizingMode","ToolPunchThroughDistance","ZOffset"}}
db["GuiBase3d"]={super="GuiBase",props={"Color3","Transparency","Visible"}}
db["FloorWire"]={super="GuiBase3d",props={"CycleOffset","StudsBetweenTextures","Texture","TextureSize","Velocity","WireRadius"}}
db["InstanceAdornment"]={super="GuiBase3d",props={}}
db["SelectionBox"]={super="InstanceAdornment",props={"LineThickness","SurfaceColor3","SurfaceTransparency"}}
db["PVAdornment"]={super="GuiBase3d",props={}}
db["HandleAdornment"]={super="PVAdornment",props={"AdornCullingMode","AlwaysOnTop","CFrame","SizeRelativeOffset","ZIndex"}}
db["BoxHandleAdornment"]={super="HandleAdornment",props={"Shading","Size"}}
db["ConeHandleAdornment"]={super="HandleAdornment",props={"Height","Hollow","Radius","Shading"}}
db["CylinderHandleAdornment"]={super="HandleAdornment",props={"Angle","Height","InnerRadius","Radius","Shading"}}
db["ImageHandleAdornment"]={super="HandleAdornment",props={"Image","Size"}}
db["LineHandleAdornment"]={super="HandleAdornment",props={"Length","Thickness"}}
db["PyramidHandleAdornment"]={super="HandleAdornment",props={"Height","Shading","Sides","Size"}}
db["SphereHandleAdornment"]={super="HandleAdornment",props={"Radius","Shading"}}
db["WireframeHandleAdornment"]={super="HandleAdornment",props={"Scale","Thickness"}}
db["ParabolaAdornment"]={super="PVAdornment",props={}}
db["SelectionSphere"]={super="PVAdornment",props={"SurfaceColor3","SurfaceTransparency"}}
db["PartAdornment"]={super="GuiBase3d",props={}}
db["HandlesBase"]={super="PartAdornment",props={}}
db["ArcHandles"]={super="HandlesBase",props={"Axes"}}
db["Handles"]={super="HandlesBase",props={"Faces","Style"}}
db["SurfaceSelection"]={super="PartAdornment",props={"TargetSurface"}}
db["SelectionLasso"]={super="GuiBase3d",props={}}
db["SelectionPartLasso"]={super="SelectionLasso",props={}}
db["SelectionPointLasso"]={super="SelectionLasso",props={"Point"}}
db["Path2D"]={super="GuiBase",props={"Closed","Color3","Thickness","Visible","ZIndex"}}
db["GuiService"]={super="Instance",props={"AutoSelectGuiEnabled","GuiNavigationEnabled","TouchControlsEnabled"}}
db["GuidRegistryService"]={super="Instance",props={}}
db["HapticEffect"]={super="Instance",props={"Looped","Position","Radius","Type"}}
db["HapticService"]={super="Instance",props={}}
db["HarmonyService"]={super="Instance",props={}}
db["HeapProfilerService"]={super="Instance",props={}}
db["HeatmapService"]={super="Instance",props={}}
db["HeightmapImporterService"]={super="Instance",props={}}
db["HiddenSurfaceRemovalAsset"]={super="Instance",props={}}
db["Highlight"]={super="Instance",props={"DepthMode","Enabled","FillColor","FillTransparency","OutlineColor","OutlineTransparency"}}
db["Hopper"]={super="Instance",props={}}
db["HttpRbxApiService"]={super="Instance",props={}}
db["HttpRequest"]={super="Instance",props={}}
db["HttpService"]={super="Instance",props={}}
db["Humanoid"]={super="Instance",props={"AutoJumpEnabled","AutoRotate","AutomaticScalingEnabled","BreakJointsOnDeath","CameraOffset","DisplayDistanceType","DisplayName","EvaluateStateMachine","Health","HealthDisplayDistance","HealthDisplayType","HipHeight","Jump","JumpHeight","JumpPower","MaxHealth","MaxSlopeAngle","NameDisplayDistance","NameOcclusion","PlatformStand","RequiresNeck","RigType","Sit","TargetPoint","UseJumpPower","WalkSpeed","WalkToPoint"}}
db["HumanoidDescription"]={super="Instance",props={"BackAccessory","BodyTypeScale","ClimbAnimation","DepthScale","Face","FaceAccessory","FallAnimation","FrontAccessory","GraphicTShirt","HairAccessory","HatAccessory","Head","HeadColor","HeadScale","HeightScale","IdleAnimation","JumpAnimation","LeftArm","LeftArmColor","LeftLeg","LeftLegColor","MoodAnimation","NeckAccessory","Pants","ProportionScale","RightArm","RightArmColor","RightLeg","RightLegColor","RunAnimation","Shirt","ShouldersAccessory","StaticFacialAnimation","SwimAnimation","Torso","TorsoColor","UseAvatarSettings","WaistAccessory","WalkAnimation","WidthScale"}}
db["HumanoidRigDescription"]={super="Instance",props={"ChestRangeMax","ChestRangeMin","ChestSize","ChestTposeAdjustment","HeadBaseRangeMax","HeadBaseRangeMin","HeadBaseSize","HeadBaseTposeAdjustment","LeftAnkleRangeMax","LeftAnkleRangeMin","LeftAnkleSize","LeftAnkleTposeAdjustment","LeftClavicleRangeMax","LeftClavicleRangeMin","LeftClavicleSize","LeftClavicleTposeAdjustment","LeftElbowRangeMax","LeftElbowRangeMin","LeftElbowSize","LeftElbowTposeAdjustment","LeftHipRangeMax","LeftHipRangeMin","LeftHipSize","LeftHipTposeAdjustment","LeftKneeRangeMax","LeftKneeRangeMin","LeftKneeSize","LeftKneeTposeAdjustment","LeftShoulderRangeMax","LeftShoulderRangeMin","LeftShoulderSize","LeftShoulderTposeAdjustment","LeftToeBaseRangeMax","LeftToeBaseRangeMin","LeftToeBaseSize","LeftToeBaseTposeAdjustment","LeftWristRangeMax","LeftWristRangeMin","LeftWristSize","LeftWristTposeAdjustment","NeckRangeMax","NeckRangeMin","NeckSize","NeckTposeAdjustment","RightAnkleRangeMax","RightAnkleRangeMin","RightAnkleSize","RightAnkleTposeAdjustment","RightClavicleRangeMax","RightClavicleRangeMin","RightClavicleSize","RightClavicleTposeAdjustment","RightElbowRangeMax","RightElbowRangeMin","RightElbowSize","RightElbowTposeAdjustment","RightHipRangeMax","RightHipRangeMin","RightHipSize","RightHipTposeAdjustment","RightKneeRangeMax","RightKneeRangeMin","RightKneeSize","RightKneeTposeAdjustment","RightShoulderRangeMax","RightShoulderRangeMin","RightShoulderSize","RightShoulderTposeAdjustment","RightToeBaseRangeMax","RightToeBaseRangeMin","RightToeBaseSize","RightToeBaseTposeAdjustment","RightWristRangeMax","RightWristRangeMin","RightWristSize","RightWristTposeAdjustment","RootRangeMax","RootRangeMin","RootSize","RootTposeAdjustment","SpineRangeMax","SpineRangeMin","SpineSize","SpineTposeAdjustment","WaistRangeMax","WaistRangeMin","WaistSize","WaistTposeAdjustment"}}
db["IKControl"]={super="Instance",props={"Enabled","EndEffectorOffset","Offset","Priority","SmoothTime","Type","Weight"}}
db["ILegacyStudioBridge"]={super="Instance",props={}}
db["LegacyStudioBridge"]={super="ILegacyStudioBridge",props={}}
db["IXPService"]={super="Instance",props={}}
db["ImportSession"]={super="Instance",props={}}
db["AssetImportSession"]={super="ImportSession",props={}}
db["IncrementalPatchBuilder"]={super="Instance",props={"AddPathsToBundle","BuildDebouncePeriod","HighCompression","SerializePatch","UseFileLevelCompressionInsteadOfChunk","ZstdCompression"}}
db["InputAction"]={super="Instance",props={"Enabled","Type"}}
db["InputBinding"]={super="Instance",props={"Backward","ClampMagnitudeToOne","Down","Forward","KeyCode","Left","PointerIndex","PressedThreshold","PrimaryModifier","ReleasedThreshold","ResponseCurve","Right","Scale","SecondaryModifier","Up","Vector2Scale","Vector3Scale"}}
db["InputContext"]={super="Instance",props={"Enabled","Priority","Sink"}}
db["InputObject"]={super="Instance",props={"Delta","KeyCode","Position","UserInputState","UserInputType"}}
db["InsertService"]={super="Instance",props={}}
db["InstanceExtensionsService"]={super="Instance",props={}}
db["InstanceFileSyncService"]={super="Instance",props={}}
db["InternalSyncItem"]={super="Instance",props={}}
db["InternalSyncService"]={super="Instance",props={}}
db["JointInstance"]={super="Instance",props={"C0","C1","Enabled"}}
db["DynamicRotate"]={super="JointInstance",props={"BaseAngle"}}
db["RotateP"]={super="DynamicRotate",props={}}
db["RotateV"]={super="DynamicRotate",props={}}
db["Glue"]={super="JointInstance",props={"F0","F1","F2","F3"}}
db["ManualSurfaceJointInstance"]={super="JointInstance",props={}}
db["ManualGlue"]={super="ManualSurfaceJointInstance",props={}}
db["ManualWeld"]={super="ManualSurfaceJointInstance",props={}}
db["Motor"]={super="JointInstance",props={"CurrentAngle","DesiredAngle","MaxVelocity"}}
db["Motor6D"]={super="Motor",props={}}
db["Rotate"]={super="JointInstance",props={}}
db["Snap"]={super="JointInstance",props={}}
db["VelocityMotor"]={super="JointInstance",props={"CurrentAngle","DesiredAngle","MaxVelocity"}}
db["Weld"]={super="JointInstance",props={}}
db["JointsService"]={super="Instance",props={}}
db["KeyboardService"]={super="Instance",props={}}
db["Keyframe"]={super="Instance",props={"Time"}}
db["KeyframeMarker"]={super="Instance",props={"Value"}}
db["KeyframeSequenceProvider"]={super="Instance",props={}}
db["LSPFileSyncService"]={super="Instance",props={}}
db["LanguageService"]={super="Instance",props={}}
db["Light"]={super="Instance",props={"Brightness","Color","Enabled","Shadows"}}
db["PointLight"]={super="Light",props={"Range"}}
db["SpotLight"]={super="Light",props={"Angle","Face","Range"}}
db["SurfaceLight"]={super="Light",props={"Angle","Face","Range"}}
db["Lighting"]={super="Instance",props={"Ambient","Brightness","ClockTime","ColorShift_Bottom","ColorShift_Top","EnvironmentDiffuseScale","EnvironmentSpecularScale","ExposureCompensation","FogColor","FogEnd","FogStart","GeographicLatitude","GlobalShadows","OutdoorAmbient","ShadowSoftness","TimeOfDay"}}
db["LinkingService"]={super="Instance",props={}}
db["LiveScriptingService"]={super="Instance",props={}}
db["LiveSyncService"]={super="Instance",props={}}
db["LocalStorageService"]={super="Instance",props={}}
db["AppStorageService"]={super="LocalStorageService",props={}}
db["UserStorageService"]={super="LocalStorageService",props={}}
db["LocalizationService"]={super="Instance",props={}}
db["LocalizationTable"]={super="Instance",props={"SourceLocaleId"}}
db["CloudLocalizationTable"]={super="LocalizationTable",props={}}
db["LodDataEntity"]={super="Instance",props={}}
db["LodDataService"]={super="Instance",props={}}
db["LogReporterService"]={super="Instance",props={}}
db["LogService"]={super="Instance",props={}}
db["LoginService"]={super="Instance",props={}}
db["LuaSettings"]={super="Instance",props={}}
db["LuaSourceContainer"]={super="Instance",props={}}
db["AuroraScript"]={super="LuaSourceContainer",props={}}
db["BaseScript"]={super="LuaSourceContainer",props={"Disabled","Enabled"}}
db["CoreScript"]={super="BaseScript",props={}}
db["Script"]={super="BaseScript",props={}}
db["LocalScript"]={super="Script",props={}}
db["ModuleScript"]={super="LuaSourceContainer",props={}}
db["LuaWebService"]={super="Instance",props={}}
db["LuauScriptAnalyzerService"]={super="Instance",props={}}
db["MLModelDeliveryService"]={super="Instance",props={}}
db["MLService"]={super="Instance",props={}}
db["MakeupDescription"]={super="Instance",props={"AssetId","MakeupType","Order"}}
db["MarkerCurve"]={super="Instance",props={}}
db["MarketplaceService"]={super="Instance",props={}}
db["MatchmakingService"]={super="Instance",props={}}
db["MaterialGenerationService"]={super="Instance",props={}}
db["MaterialService"]={super="Instance",props={}}
db["MaterialVariant"]={super="Instance",props={"AlphaMode","CustomPhysicalProperties","EmissiveStrength","EmissiveTint","MaterialPattern","StudsPerTile"}}
db["MemStorageConnection"]={super="Instance",props={}}
db["MemStorageService"]={super="Instance",props={}}
db["MemoryStoreHashMap"]={super="Instance",props={}}
db["MemoryStoreQueue"]={super="Instance",props={}}
db["MemoryStoreService"]={super="Instance",props={}}
db["MemoryStoreSortedMap"]={super="Instance",props={}}
db["Message"]={super="Instance",props={"Text"}}
db["Hint"]={super="Message",props={}}
db["MessageBusConnection"]={super="Instance",props={}}
db["MessageBusService"]={super="Instance",props={}}
db["MessagingService"]={super="Instance",props={}}
db["MetaBreakpoint"]={super="Instance",props={}}
db["MetaBreakpointContext"]={super="Instance",props={}}
db["MetaBreakpointManager"]={super="Instance",props={}}
db["MicroProfilerService"]={super="Instance",props={}}
db["ModerationService"]={super="Instance",props={}}
db["Mouse"]={super="Instance",props={"Icon"}}
db["PlayerMouse"]={super="Mouse",props={}}
db["PluginMouse"]={super="Mouse",props={}}
db["MouseService"]={super="Instance",props={}}
db["MultipleDocumentInterfaceInstance"]={super="Instance",props={}}
db["NetworkMarker"]={super="Instance",props={}}
db["NetworkPeer"]={super="Instance",props={}}
db["NetworkClient"]={super="NetworkPeer",props={}}
db["NetworkServer"]={super="NetworkPeer",props={}}
db["NetworkReplicator"]={super="Instance",props={}}
db["ClientReplicator"]={super="NetworkReplicator",props={}}
db["ServerReplicator"]={super="NetworkReplicator",props={}}
db["NetworkSettings"]={super="Instance",props={"IncomingReplicationLag","PrintJoinSizeBreakdown","PrintPhysicsErrors","PrintStreamInstanceQuota","RandomizeJoinInstanceOrder","RenderStreamedRegions","ShowActiveAnimationAsset"}}
db["NoCollisionConstraint"]={super="Instance",props={"Enabled"}}
db["Noise"]={super="Instance",props={}}
db["NotificationService"]={super="Instance",props={}}
db["OmniRecommendationsService"]={super="Instance",props={}}
db["OpenCloudApiV1"]={super="Instance",props={}}
db["OpenCloudService"]={super="Instance",props={}}
db["OperationGraph"]={super="Instance",props={}}
db["PVInstance"]={super="Instance",props={}}
db["BasePart"]={super="PVInstance",props={"Anchored","AssemblyAngularVelocity","AssemblyLinearVelocity","AudioCanCollide","BackSurface","BottomSurface","BrickColor","CFrame","CanCollide","CanQuery","CanTouch","CastShadow","CollisionGroup","Color","CustomPhysicalProperties","EnableFluidForces","FrontSurface","LeftSurface","Locked","Massless","Material","MaterialVariant","PivotOffset","Reflectance","RightSurface","RootPriority","Rotation","Size","TopSurface","Transparency"}}
db["CornerWedgePart"]={super="BasePart",props={}}
db["FormFactorPart"]={super="BasePart",props={}}
db["Part"]={super="FormFactorPart",props={"Shape"}}
db["FlagStand"]={super="Part",props={"TeamColor"}}
db["Platform"]={super="Part",props={}}
db["Seat"]={super="Part",props={"Disabled"}}
db["SkateboardPlatform"]={super="Part",props={"Steer","StickyWheels","Throttle"}}
db["SpawnLocation"]={super="Part",props={"AllowTeamChangeOnTouch","Duration","Enabled","Neutral","TeamColor"}}
db["WedgePart"]={super="FormFactorPart",props={}}
db["Terrain"]={super="BasePart",props={"WaterColor","WaterReflectance","WaterTransparency","WaterWaveSize","WaterWaveSpeed"}}
db["TriangleMeshPart"]={super="BasePart",props={}}
db["MeshPart"]={super="TriangleMeshPart",props={"TextureID"}}
db["PartOperation"]={super="TriangleMeshPart",props={"UsePartColor"}}
db["IntersectOperation"]={super="PartOperation",props={}}
db["NegateOperation"]={super="PartOperation",props={}}
db["UnionOperation"]={super="PartOperation",props={}}
db["TrussPart"]={super="BasePart",props={"Style"}}
db["VehicleSeat"]={super="BasePart",props={"Disabled","HeadsUpDisplay","MaxSpeed","Steer","SteerFloat","Throttle","ThrottleFloat","Torque","TurnSpeed"}}
db["Camera"]={super="PVInstance",props={"CFrame","CameraType","DiagonalFieldOfView","FieldOfView","FieldOfViewMode","Focus","HeadLocked","HeadScale","MaxAxisFieldOfView","VRTiltAndRollEnabled"}}
db["Model"]={super="PVInstance",props={"ModelStreamingMode","WorldPivot"}}
db["Actor"]={super="Model",props={}}
db["BackpackItem"]={super="Model",props={"TextureId"}}
db["HopperBin"]={super="BackpackItem",props={"Active","BinType"}}
db["Tool"]={super="BackpackItem",props={"CanBeDropped","Enabled","Grip","ManualActivationOnly","RequiresHandle","ToolTip"}}
db["Flag"]={super="Tool",props={"TeamColor"}}
db["Status"]={super="Model",props={}}
db["WorldRoot"]={super="Model",props={}}
db["Workspace"]={super="WorldRoot",props={"AirDensity","AirTurbulenceIntensity","AllowThirdPartySales","ClientAnimatorThrottling","DistributedGameTime","GlobalWind","Gravity","InsertPoint","Retargeting"}}
db["WorldModel"]={super="WorldRoot",props={}}
db["PackageLink"]={super="Instance",props={}}
db["PackageService"]={super="Instance",props={}}
db["PackageUIService"]={super="Instance",props={}}
db["Pages"]={super="Instance",props={}}
db["AudioPages"]={super="Pages",props={}}
db["BanHistoryPages"]={super="Pages",props={}}
db["CapturesPages"]={super="Pages",props={}}
db["CatalogPages"]={super="Pages",props={}}
db["DataStoreKeyPages"]={super="Pages",props={}}
db["DataStoreListingPages"]={super="Pages",props={}}
db["DataStorePages"]={super="Pages",props={}}
db["DataStoreVersionPages"]={super="Pages",props={}}
db["FriendPages"]={super="Pages",props={}}
db["InventoryPages"]={super="Pages",props={}}
db["EmotesPages"]={super="InventoryPages",props={}}
db["MemoryStoreHashMapPages"]={super="Pages",props={}}
db["OutfitPages"]={super="Pages",props={}}
db["RecommendationPages"]={super="Pages",props={}}
db["StandardPages"]={super="Pages",props={}}
db["PartOperationAsset"]={super="Instance",props={}}
db["ParticleEmitter"]={super="Instance",props={"Acceleration","Brightness","Color","Drag","EmissionDirection","Enabled","FlipbookBlendFrames","FlipbookFramerate","FlipbookIncompatible","FlipbookLayout","FlipbookMode","FlipbookSizeX","FlipbookSizeY","FlipbookStartRandom","Lifetime","LightEmission","LightInfluence","LockedToPart","Orientation","Rate","RotSpeed","Rotation","Shape","ShapeInOut","ShapePartial","ShapeStyle","Size","Speed","SpreadAngle","Squash","Texture","TimeScale","Transparency","VelocityInheritance","WindAffectsDrag","ZOffset"}}
db["PartyEmulatorService"]={super="Instance",props={}}
db["PatchBundlerFileWatch"]={super="Instance",props={}}
db["PatchMapping"]={super="Instance",props={"FlattenTree","PatchId","TargetPath"}}
db["Path"]={super="Instance",props={}}
db["PathfindingLink"]={super="Instance",props={"IsBidirectional","Label"}}
db["PathfindingModifier"]={super="Instance",props={"Label","PassThrough"}}
db["PathfindingService"]={super="Instance",props={}}
db["PausedState"]={super="Instance",props={}}
db["PausedStateBreakpoint"]={super="PausedState",props={}}
db["PausedStateException"]={super="PausedState",props={}}
db["PerformanceControlService"]={super="Instance",props={}}
db["PermissionsService"]={super="Instance",props={}}
db["PhysicsService"]={super="Instance",props={}}
db["PhysicsSettings"]={super="Instance",props={}}
db["PlaceAssetIdsService"]={super="Instance",props={}}
db["PlaceStatsService"]={super="Instance",props={}}
db["PlacesService"]={super="Instance",props={}}
db["PlatformCloudStorageService"]={super="Instance",props={}}
db["PlatformFriendsService"]={super="Instance",props={}}
db["PlatformLibraries"]={super="Instance",props={}}
db["Player"]={super="Instance",props={"AutoJumpEnabled","CameraMaxZoomDistance","CameraMinZoomDistance","CameraMode","CanLoadCharacterAppearance","CharacterAppearanceId","DevCameraOcclusionMode","DevComputerCameraMode","DevComputerMovementMode","DevEnableMouseLock","DevTouchCameraMode","DevTouchMovementMode","DisplayName","HasVerifiedBadge","HealthDisplayDistance","NameDisplayDistance","Neutral","TeamColor","UserId"}}
db["PlayerData"]={super="Instance",props={}}
db["PlayerDataRecord"]={super="Instance",props={}}
db["PlayerDataRecordConfig"]={super="Instance",props={}}
db["PlayerDataService"]={super="Instance",props={"LoadFailureBehavior"}}
db["PlayerEmulatorService"]={super="Instance",props={}}
db["PlayerHydrationService"]={super="Instance",props={}}
db["PlayerScripts"]={super="Instance",props={}}
db["PlayerViewService"]={super="Instance",props={}}
db["Players"]={super="Instance",props={"CharacterAutoLoads","RespawnTime"}}
db["Plugin"]={super="Instance",props={}}
db["PluginAction"]={super="Instance",props={}}
db["PluginCapabilities"]={super="Instance",props={}}
db["PluginDebugService"]={super="Instance",props={}}
db["PluginDragEvent"]={super="Instance",props={}}
db["PluginGuiService"]={super="Instance",props={}}
db["PluginManagementService"]={super="Instance",props={}}
db["PluginManager"]={super="Instance",props={}}
db["PluginManagerInterface"]={super="Instance",props={}}
db["PluginMenu"]={super="Instance",props={"Icon","Title"}}
db["PluginPolicyService"]={super="Instance",props={}}
db["PluginToolbar"]={super="Instance",props={}}
db["PluginToolbarButton"]={super="Instance",props={"ClickableWhenViewportHidden","Enabled","Icon"}}
db["PointsService"]={super="Instance",props={}}
db["PolicyService"]={super="Instance",props={}}
db["PoseBase"]={super="Instance",props={"EasingDirection","EasingStyle","Weight"}}
db["NumberPose"]={super="PoseBase",props={"Value"}}
db["Pose"]={super="PoseBase",props={"CFrame"}}
db["PostEffect"]={super="Instance",props={"Enabled"}}
db["BloomEffect"]={super="PostEffect",props={"Intensity","Size","Threshold"}}
db["BlurEffect"]={super="PostEffect",props={"Size"}}
db["ColorCorrectionEffect"]={super="PostEffect",props={"Brightness","Contrast","Saturation","TintColor"}}
db["ColorGradingEffect"]={super="PostEffect",props={"TonemapperPreset"}}
db["DepthOfFieldEffect"]={super="PostEffect",props={"FarIntensity","FocusDistance","InFocusRadius","NearIntensity"}}
db["SunRaysEffect"]={super="PostEffect",props={"Intensity","Spread"}}
db["ProcessInstancePhysicsService"]={super="Instance",props={}}
db["ProximityPrompt"]={super="Instance",props={"ActionText","AutoLocalize","ClickablePrompt","Enabled","Exclusivity","GamepadKeyCode","HoldDuration","KeyboardKeyCode","MaxActivationDistance","MaxIndicatorDistance","ObjectText","RequiresLineOfSight","Style","UIOffset"}}
db["ProximityPromptService"]={super="Instance",props={"Enabled","MaxIndicatorsVisible","MaxPromptsVisible"}}
db["PublishService"]={super="Instance",props={}}
db["RTAnimationTracker"]={super="Instance",props={}}
db["RbxAnalyticsService"]={super="Instance",props={}}
db["RecommendationService"]={super="Instance",props={}}
db["ReflectionMetadata"]={super="Instance",props={}}
db["ReflectionMetadataCallbacks"]={super="Instance",props={}}
db["ReflectionMetadataClasses"]={super="Instance",props={}}
db["ReflectionMetadataEnums"]={super="Instance",props={}}
db["ReflectionMetadataEvents"]={super="Instance",props={}}
db["ReflectionMetadataFunctions"]={super="Instance",props={}}
db["ReflectionMetadataItem"]={super="Instance",props={"Browsable","ClassCategory","ClientOnly","Constraint","Deprecated","EditingDisabled","EditorType","FFlag","IsBackend","PropertyOrder","ScriptContext","ServerOnly","SliderScaling","UIMaximum","UIMinimum","UINumTicks"}}
db["ReflectionMetadataClass"]={super="ReflectionMetadataItem",props={"ExplorerImageIndex","ExplorerOrder","Insertable","PreferredParent"}}
db["ReflectionMetadataEnum"]={super="ReflectionMetadataItem",props={}}
db["ReflectionMetadataEnumItem"]={super="ReflectionMetadataItem",props={}}
db["ReflectionMetadataMember"]={super="ReflectionMetadataItem",props={}}
db["ReflectionMetadataProperties"]={super="Instance",props={}}
db["ReflectionMetadataYieldFunctions"]={super="Instance",props={}}
db["ReflectionService"]={super="Instance",props={}}
db["RemoteCommandService"]={super="Instance",props={}}
db["RemoteCursorService"]={super="Instance",props={}}
db["RemoteDebuggerServer"]={super="Instance",props={}}
db["RemoteFunction"]={super="Instance",props={}}
db["RenderSettings"]={super="Instance",props={"AutoFRMLevel","EagerBulkExecution","EditQualityLevel","ExportMergeByMaterial","FrameRateManager","GraphicsMode","MeshCacheSize","MeshPartDetailLevel","QualityLevel","ReloadAssets","RenderCSGTrianglesDebug","ShowBoundingBoxes","ViewMode"}}
db["RenderingTest"]={super="Instance",props={"CFrame","ComparisonDiffThreshold","ComparisonMethod","ComparisonPsnrThreshold","Description","FieldOfView","PerfTest","QualityAuto","QualityLevel","RenderingTestFrameCount","ShouldSkip","Ticket","Timeout"}}
db["ReplicatedFirst"]={super="Instance",props={}}
db["ReplicatedStorage"]={super="Instance",props={}}
db["RibbonNotificationService"]={super="Instance",props={}}
db["RobloxPluginGuiService"]={super="Instance",props={}}
db["RobloxReplicatedStorage"]={super="Instance",props={}}
db["RobloxSerializableInstance"]={super="Instance",props={}}
db["RobloxServerStorage"]={super="Instance",props={}}
db["RolloutValidation"]={super="Instance",props={}}
db["RolloutValidationService"]={super="Instance",props={}}
db["RomarkRbxAnalyticsService"]={super="Instance",props={}}
db["RomarkService"]={super="Instance",props={}}
db["RotationCurve"]={super="Instance",props={}}
db["RtMessagingService"]={super="Instance",props={}}
db["RunService"]={super="Instance",props={}}
db["RuntimeContentService"]={super="Instance",props={}}
db["RuntimeScriptService"]={super="Instance",props={}}
db["SafetyService"]={super="Instance",props={}}
db["ScreenshotHud"]={super="Instance",props={"CameraButtonIcon","CameraButtonPosition","CloseButtonPosition","CloseWhenScreenshotTaken","HideCoreGuiForCaptures","HidePlayerGuiForCaptures","Visible"}}
db["ScriptBuilder"]={super="Instance",props={}}
db["SyncScriptBuilder"]={super="ScriptBuilder",props={"CompileTarget","CoverageInfo","DebugInfo","PackAsSource"}}
db["ScriptChangeService"]={super="Instance",props={}}
db["ScriptCloneWatcher"]={super="Instance",props={}}
db["ScriptCloneWatcherHelper"]={super="Instance",props={}}
db["ScriptCommitService"]={super="Instance",props={}}
db["ScriptContext"]={super="Instance",props={}}
db["ScriptDebugger"]={super="Instance",props={}}
db["ScriptDocument"]={super="Instance",props={}}
db["ScriptEditorService"]={super="Instance",props={}}
db["ScriptProfilerService"]={super="Instance",props={}}
db["ScriptRegistrationService"]={super="Instance",props={}}
db["ScriptRuntime"]={super="Instance",props={}}
db["ScriptService"]={super="Instance",props={}}
db["Selection"]={super="Instance",props={}}
db["SelectionHighlightManager"]={super="Instance",props={}}
db["SensorBase"]={super="Instance",props={"UpdateType"}}
db["AtmosphereSensor"]={super="SensorBase",props={}}
db["BuoyancySensor"]={super="SensorBase",props={"FullySubmerged","TouchingSurface"}}
db["ControllerSensor"]={super="SensorBase",props={}}
db["ControllerPartSensor"]={super="ControllerSensor",props={"HitFrame","HitNormal","SearchDistance","SensorMode"}}
db["FluidForceSensor"]={super="SensorBase",props={}}
db["SerializationService"]={super="Instance",props={}}
db["ServerScriptService"]={super="Instance",props={}}
db["ServerStorage"]={super="Instance",props={}}
db["ServiceProvider"]={super="Instance",props={}}
db["DataModel"]={super="ServiceProvider",props={}}
db["GenericSettings"]={super="ServiceProvider",props={}}
db["GlobalSettings"]={super="GenericSettings",props={}}
db["UserSettings"]={super="GenericSettings",props={}}
db["ServiceVisibilityService"]={super="Instance",props={}}
db["SessionCheckService"]={super="Instance",props={}}
db["SessionService"]={super="Instance",props={}}
db["SharedTableRegistry"]={super="Instance",props={}}
db["Sky"]={super="Instance",props={"CelestialBodiesShown","MoonAngularSize","MoonTextureId","SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxOrientation","SkyboxRt","SkyboxUp","StarCount","SunAngularSize","SunTextureId"}}
db["SlimAnimationDataEntity"]={super="Instance",props={}}
db["SlimAnimationReplicationService"]={super="Instance",props={}}
db["SlimReplicationService"]={super="Instance",props={}}
db["SlimService"]={super="Instance",props={}}
db["Smoke"]={super="Instance",props={"Color","Enabled","Opacity","RiseVelocity","Size","TimeScale"}}
db["SmoothVoxelsUpgraderService"]={super="Instance",props={}}
db["SnippetService"]={super="Instance",props={}}
db["SocialService"]={super="Instance",props={}}
db["Sound"]={super="Instance",props={"AcousticSimulationEnabled","LoopRegion","Looped","PlayOnRemove","PlaybackRegion","PlaybackRegionsEnabled","PlaybackSpeed","Playing","RollOffMaxDistance","RollOffMinDistance","RollOffMode","SoundId","TimePosition","Volume"}}
db["SoundEffect"]={super="Instance",props={"Enabled","Priority"}}
db["ChorusSoundEffect"]={super="SoundEffect",props={"Depth","Mix","Rate"}}
db["CompressorSoundEffect"]={super="SoundEffect",props={"Attack","GainMakeup","Ratio","Release","Threshold"}}
db["CustomSoundEffect"]={super="SoundEffect",props={}}
db["AssetSoundEffect"]={super="CustomSoundEffect",props={}}
db["ChannelSelectorSoundEffect"]={super="CustomSoundEffect",props={"Channel"}}
db["DistortionSoundEffect"]={super="SoundEffect",props={"Level"}}
db["EchoSoundEffect"]={super="SoundEffect",props={"Delay","DryLevel","Feedback","WetLevel"}}
db["EqualizerSoundEffect"]={super="SoundEffect",props={"HighGain","LowGain","MidGain"}}
db["FlangeSoundEffect"]={super="SoundEffect",props={"Depth","Mix","Rate"}}
db["PitchShiftSoundEffect"]={super="SoundEffect",props={"Octave"}}
db["ReverbSoundEffect"]={super="SoundEffect",props={"DecayTime","Density","Diffusion","DryLevel","WetLevel"}}
db["TremoloSoundEffect"]={super="SoundEffect",props={"Depth","Duty","Frequency"}}
db["SoundGroup"]={super="Instance",props={"Volume"}}
db["SoundService"]={super="Instance",props={"AcousticSimulationEnabled","AmbientReverb","DistanceFactor","DopplerScale","RespectFilteringEnabled","RolloffScale"}}
db["SoundShimService"]={super="Instance",props={}}
db["Sparkles"]={super="Instance",props={"Enabled","SparkleColor","TimeScale"}}
db["SpawnerService"]={super="Instance",props={}}
db["StackFrame"]={super="Instance",props={}}
db["StandalonePluginScripts"]={super="Instance",props={}}
db["StartPageService"]={super="Instance",props={}}
db["StarterGear"]={super="Instance",props={}}
db["StarterPack"]={super="Instance",props={}}
db["StarterPlayer"]={super="Instance",props={"AutoJumpEnabled","CameraMaxZoomDistance","CameraMinZoomDistance","CameraMode","CharacterBreakJointsOnDeath","CharacterJumpHeight","CharacterJumpPower","CharacterMaxSlopeAngle","CharacterUseJumpPower","CharacterWalkSpeed","ClassicDeath","DevCameraOcclusionMode","DevComputerCameraMovementMode","DevComputerMovementMode","DevTouchCameraMovementMode","DevTouchMovementMode","EnableMouseLockOption","HealthDisplayDistance","LoadCharacterAppearance","LuaCharacterController","NameDisplayDistance","UserEmotesEnabled"}}
db["StarterPlayerScripts"]={super="Instance",props={}}
db["StarterCharacterScripts"]={super="StarterPlayerScripts",props={}}
db["StartupMessageService"]={super="Instance",props={}}
db["Stats"]={super="Instance",props={}}
db["StatsItem"]={super="Instance",props={}}
db["RunningAverageItemDouble"]={super="StatsItem",props={}}
db["RunningAverageItemInt"]={super="StatsItem",props={}}
db["RunningAverageTimeIntervalItem"]={super="StatsItem",props={}}
db["TotalCountTimeIntervalItem"]={super="StatsItem",props={}}
db["StopWatchReporter"]={super="Instance",props={}}
db["Studio"]={super="Instance",props={"ActionOnStopSync","CommandBarLocalState","DeprecatedObjectsShown","Font","HintColor","InformationColor","LuaDebuggerEnabled","PermissionLevelShown","PluginDebuggingEnabled","PluginsDir","Rulers","RuntimeUndoBehavior","ScriptTimeoutLength"}}
db["StudioAssetService"]={super="Instance",props={}}
db["StudioAttachment"]={super="Instance",props={"AutoHideParent","IsArrowVisible","Offset","SourceAnchorPoint","TargetAnchorPoint"}}
db["StudioCallout"]={super="Instance",props={}}
db["StudioCameraService"]={super="Instance",props={}}
db["StudioData"]={super="Instance",props={}}
db["StudioDeviceEmulatorService"]={super="Instance",props={}}
db["StudioObjectBase"]={super="Instance",props={}}
db["StudioWidget"]={super="StudioObjectBase",props={}}
db["StudioPublishService"]={super="Instance",props={}}
db["StudioScriptDebugEventListener"]={super="Instance",props={}}
db["StudioSdkService"]={super="Instance",props={}}
db["StudioService"]={super="Instance",props={"UseLocalSpace"}}
db["StudioTestService"]={super="Instance",props={}}
db["StudioTheme"]={super="Instance",props={}}
db["StudioUserService"]={super="Instance",props={}}
db["StudioWidgetsService"]={super="Instance",props={}}
db["StyleBase"]={super="Instance",props={}}
db["StyleRule"]={super="StyleBase",props={"Priority","Selector"}}
db["StyleSheet"]={super="StyleBase",props={}}
db["StyleDerive"]={super="Instance",props={"Priority"}}
db["StyleLink"]={super="Instance",props={}}
db["StyleQuery"]={super="Instance",props={}}
db["StylingService"]={super="Instance",props={}}
db["SurfaceAppearance"]={super="Instance",props={"AlphaMode","Color","EmissiveStrength","EmissiveTint"}}
db["SystemThemeService"]={super="Instance",props={}}
db["TaskScheduler"]={super="Instance",props={"ThreadPoolConfig"}}
db["Team"]={super="Instance",props={"AutoAssignable","TeamColor"}}
db["TeamCreateData"]={super="Instance",props={}}
db["TeamCreatePublishService"]={super="Instance",props={}}
db["TeamCreateService"]={super="Instance",props={}}
db["Teams"]={super="Instance",props={}}
db["TelemetryService"]={super="Instance",props={}}
db["TeleportAsyncResult"]={super="Instance",props={}}
db["TeleportOptions"]={super="Instance",props={"ReservedServerAccessCode","ServerInstanceId","ShouldReserveServer"}}
db["TeleportService"]={super="Instance",props={}}
db["TemporaryCageMeshProvider"]={super="Instance",props={}}
db["TemporaryScriptService"]={super="Instance",props={}}
db["TerrainDetail"]={super="Instance",props={"EmissiveStrength","EmissiveTint","Face","MaterialPattern","StudsPerTile"}}
db["TerrainRegion"]={super="Instance",props={}}
db["TestCase"]={super="Instance",props={}}
db["TestService"]={super="Instance",props={"AutoRuns","Description","ExecuteWithStudioRun","IsPhysicsEnvironmentalThrottled","IsSleepAllowed","NumberOfPlayers","SimulateSecondsLag","ThrottlePhysicsToRealtime","Timeout"}}
db["TextBoxService"]={super="Instance",props={}}
db["TextChannel"]={super="Instance",props={}}
db["TextChatCommand"]={super="Instance",props={"AutocompleteVisible","Enabled","PrimaryAlias","SecondaryAlias"}}
db["TextChatConfigurations"]={super="Instance",props={}}
db["BubbleChatConfiguration"]={super="TextChatConfigurations",props={"AdorneeName","BackgroundColor3","BackgroundTransparency","BubbleDuration","BubblesSpacing","Enabled","FontFace","LocalPlayerStudsOffset","MaxBubbles","MaxDistance","MinimizeDistance","TailVisible","TextColor3","TextSize","VerticalStudsOffset"}}
db["ChannelTabsConfiguration"]={super="TextChatConfigurations",props={"BackgroundColor3","BackgroundTransparency","Enabled","FontFace","HoverBackgroundColor3","SelectedTabTextColor3","TextColor3","TextSize","TextStrokeColor3","TextStrokeTransparency"}}
db["ChatInputBarConfiguration"]={super="TextChatConfigurations",props={"AutocompleteEnabled","BackgroundColor3","BackgroundTransparency","Enabled","FontFace","KeyboardKeyCode","PlaceholderColor3","TextColor3","TextSize","TextStrokeColor3","TextStrokeTransparency"}}
db["ChatWindowConfiguration"]={super="TextChatConfigurations",props={"BackgroundColor3","BackgroundTransparency","Enabled","FontFace","HeightScale","HorizontalAlignment","TextColor3","TextSize","TextStrokeColor3","TextStrokeTransparency","VerticalAlignment","WidthScale"}}
db["TextChatMessage"]={super="Instance",props={"MessageId","Metadata","PrefixText","Status","Text","Timestamp","Translation"}}
db["TextChatMessageProperties"]={super="Instance",props={"PrefixText","Text","Translation"}}
db["BubbleChatMessageProperties"]={super="TextChatMessageProperties",props={"BackgroundColor3","BackgroundTransparency","FontFace","TailVisible","TextColor3","TextSize"}}
db["ChatWindowMessageProperties"]={super="TextChatMessageProperties",props={"FontFace","TextColor3","TextSize","TextStrokeColor3","TextStrokeTransparency"}}
db["TextChatService"]={super="Instance",props={}}
db["TextFilterResult"]={super="Instance",props={}}
db["TextFilterTranslatedResult"]={super="Instance",props={}}
db["TextGenerator"]={super="Instance",props={"Seed","SystemPrompt","Temperature","TopP"}}
db["TextService"]={super="Instance",props={}}
db["TextSource"]={super="Instance",props={"CanSend"}}
db["TextureGenerationPartGroup"]={super="Instance",props={}}
db["TextureGenerationService"]={super="Instance",props={}}
db["TextureGenerationUnwrappingRequest"]={super="Instance",props={}}
db["ThirdPartyUserService"]={super="Instance",props={}}
db["ThreadState"]={super="Instance",props={}}
db["TimerService"]={super="Instance",props={}}
db["ToastNotificationService"]={super="Instance",props={}}
db["TouchInputService"]={super="Instance",props={}}
db["TouchTransmitter"]={super="Instance",props={}}
db["TraceRouteService"]={super="Instance",props={}}
db["TracerService"]={super="Instance",props={}}
db["TrackerLodController"]={super="Instance",props={"AudioMode","VideoExtrapolationMode","VideoLodMode","VideoMode"}}
db["TrackerStreamAnimation"]={super="Instance",props={}}
db["Trail"]={super="Instance",props={"Brightness","Color","Enabled","FaceCamera","Lifetime","LightEmission","LightInfluence","MaxLength","MinLength","Texture","TextureLength","TextureMode","Transparency","WidthScale"}}
db["Translator"]={super="Instance",props={}}
db["TutorialService"]={super="Instance",props={}}
db["TweenBase"]={super="Instance",props={}}
db["Tween"]={super="TweenBase",props={}}
db["TweenService"]={super="Instance",props={}}
db["UGCAvatarService"]={super="Instance",props={}}
db["UGCValidationService"]={super="Instance",props={}}
db["UIBase"]={super="Instance",props={}}
db["UIComponent"]={super="UIBase",props={}}
db["UIConstraint"]={super="UIComponent",props={}}
db["UIAspectRatioConstraint"]={super="UIConstraint",props={"AspectRatio","AspectType","DominantAxis"}}
db["UISizeConstraint"]={super="UIConstraint",props={"MaxSize","MinSize"}}
db["UITextSizeConstraint"]={super="UIConstraint",props={"MaxTextSize","MinTextSize"}}
db["UICorner"]={super="UIComponent",props={"CornerRadius"}}
db["UIDragDetector"]={super="UIComponent",props={"ActivatedCursorIcon","BoundingBehavior","CursorIcon","DragAxis","DragRelativity","DragRotation","DragSpace","DragStyle","DragUDim2","Enabled","MaxDragAngle","MaxDragTranslation","MinDragAngle","MinDragTranslation","ResponseStyle","SelectionModeDragSpeed","SelectionModeRotateSpeed","UIDragSpeedAxisMapping"}}
db["UIFlexItem"]={super="UIComponent",props={"FlexMode","GrowRatio","ItemLineAlignment","ShrinkRatio"}}
db["UIGradient"]={super="UIComponent",props={"Color","Enabled","Offset","Rotation","Transparency"}}
db["UILayout"]={super="UIComponent",props={}}
db["UIGridStyleLayout"]={super="UILayout",props={"FillDirection","HorizontalAlignment","SortOrder","VerticalAlignment"}}
db["UIGridLayout"]={super="UIGridStyleLayout",props={"CellPadding","CellSize","FillDirectionMaxCells","StartCorner"}}
db["UIListLayout"]={super="UIGridStyleLayout",props={"HorizontalFlex","ItemLineAlignment","Padding","VerticalFlex","Wraps"}}
db["UIPageLayout"]={super="UIGridStyleLayout",props={"Animated","Circular","EasingDirection","EasingStyle","GamepadInputEnabled","Padding","ScrollWheelInputEnabled","TouchInputEnabled","TweenTime"}}
db["UITableLayout"]={super="UIGridStyleLayout",props={"FillEmptySpaceColumns","FillEmptySpaceRows","MajorAxis","Padding"}}
db["UIPadding"]={super="UIComponent",props={"PaddingBottom","PaddingLeft","PaddingRight","PaddingTop"}}
db["UIScale"]={super="UIComponent",props={"Scale"}}
db["UIShadow"]={super="UIComponent",props={"BlurRadius","Color","Offset","Spread","Transparency","ZIndex"}}
db["UIStroke"]={super="UIComponent",props={"ApplyStrokeMode","BorderOffset","BorderStrokePosition","Color","Enabled","LineJoinMode","StrokeSizingMode","Thickness","Transparency","ZIndex"}}
db["UIDragDetectorService"]={super="Instance",props={}}
db["UniqueIdLookupService"]={super="Instance",props={}}
db["UnvalidatedAssetService"]={super="Instance",props={}}
db["UserGameSettings"]={super="Instance",props={"ComputerCameraMovementMode","ComputerMovementMode","ControlMode","GamepadCameraSensitivity","MouseSensitivity","RCCProfilerRecordFrameRate","RCCProfilerRecordTimeFrame","RotationType","SavedQualityLevel","TouchCameraMovementMode","TouchMovementMode"}}
db["UserInputService"]={super="Instance",props={"MouseBehavior","MouseDeltaSensitivity","MouseIcon","MouseIconEnabled"}}
db["UserService"]={super="Instance",props={}}
db["VRService"]={super="Instance",props={"AutomaticScaling","AvatarGestures","ControllerModels","FadeOutViewOnCollision","GuiInputUserCFrame","LaserPointer"}}
db["VRStatusService"]={super="Instance",props={}}
db["ValueBase"]={super="Instance",props={}}
db["BinaryStringValue"]={super="ValueBase",props={}}
db["BoolValue"]={super="ValueBase",props={"Value"}}
db["BrickColorValue"]={super="ValueBase",props={"Value"}}
db["CFrameValue"]={super="ValueBase",props={"Value"}}
db["Color3Value"]={super="ValueBase",props={"Value"}}
db["DoubleConstrainedValue"]={super="ValueBase",props={"MaxValue","MinValue","Value"}}
db["IntConstrainedValue"]={super="ValueBase",props={"MaxValue","MinValue","Value"}}
db["IntValue"]={super="ValueBase",props={"Value"}}
db["NumberValue"]={super="ValueBase",props={"Value"}}
db["ObjectValue"]={super="ValueBase",props={}}
db["RayValue"]={super="ValueBase",props={"Value"}}
db["StringValue"]={super="ValueBase",props={"Value"}}
db["Vector3Value"]={super="ValueBase",props={"Value"}}
db["ValueCurve"]={super="Instance",props={}}
db["Vector3Curve"]={super="Instance",props={}}
db["VersionControlService"]={super="Instance",props={}}
db["VideoCaptureService"]={super="Instance",props={}}
db["VideoDeviceInput"]={super="Instance",props={"Active","CameraId","CaptureQuality"}}
db["VideoPlayer"]={super="Instance",props={"Looping","PlaybackSpeed","TimePosition","Volume"}}
db["VideoScreenCaptureService"]={super="Instance",props={}}
db["VideoService"]={super="Instance",props={}}
db["VirtualInputManager"]={super="Instance",props={}}
db["VirtualUser"]={super="Instance",props={}}
db["VisibilityCheckDispatcher"]={super="Instance",props={}}
db["Visit"]={super="Instance",props={}}
db["VisualizationMode"]={super="Instance",props={}}
db["VisualizationModeCategory"]={super="Instance",props={}}
db["VisualizationModeService"]={super="Instance",props={}}
db["VoiceChatInternal"]={super="Instance",props={}}
db["VoiceChatService"]={super="Instance",props={}}
db["WebSocketClient"]={super="Instance",props={}}
db["WebSocketService"]={super="Instance",props={}}
db["WebViewService"]={super="Instance",props={}}
db["WeldConstraint"]={super="Instance",props={"Enabled"}}
db["Wire"]={super="Instance",props={"SourceName","TargetName"}}
db["WrapDeformMeshProvider"]={super="Instance",props={}}
db["WrapTextureTransfer"]={super="Instance",props={"UVMaxBound","UVMinBound"}}
db["MLSession"]={super="Object",props={}}
db["TerrainIterateOperation"]={super="Object",props={}}
db["TerrainModifyOperation"]={super="Object",props={}}
db["TerrainReadOperation"]={super="Object",props={}}
db["TerrainWriteOperation"]={super="Object",props={}}
db["VideoSampler"]={super="Object",props={}}
db["VoxelBuffer"]={super="Object",props={}}
db["WebStreamClient"]={super="Object",props={}}
return { data = db }
end

_modules["Config"] = function()
local Config = {}

-- Set from VS Code poll response; defers risky class conversions in cursor mode
Config.CURSOR_MODE = false

-- Icon asset IDs for toolbar buttons (connect.png and disconnect.png uploaded to Roblox)
Config.CONNECT_ICON = "rbxassetid://70940333195048"
Config.DISCONNECT_ICON = "rbxassetid://112124618127933"

Config.PORT = 34872
Config.HOST = "http://127.0.0.1"
Config.POLL_INTERVAL = 0.3
-- How often to hit /api/ping while connected (server may suggest a value via /api/status).
Config.STUDIO_PING_INTERVAL = 8
Config.DEBOUNCE_TIME = 0.2

Config.SYNCED_SERVICES = {
	"Workspace",
	"Players",
	"Lighting",
	"MaterialService",
	"ReplicatedFirst",
	"ReplicatedStorage",
	"ServerScriptService",
	"ServerStorage",
	"StarterGui",
	"StarterPack",
	"StarterPlayer",
	"SoundService",
	"Teams",
	"TextChatService",
}

Config.SCRIPT_EXTENSIONS = {
	Script = ".server.lua",
	LocalScript = ".client.lua",
	ModuleScript = ".lua",
}

Config.IGNORED_PROPERTIES = {
	Name = true,
	ClassName = true,
	Archivable = true,
	DataCost = true,
	RobloxLocked = true,
}

Config.NON_SERIALIZABLE_CLASSES = {
}

return Config

end

_modules["PropertyHandler"] = function()
local PropertyHandler = {}

function PropertyHandler.serializeValue(value)
	local t = typeof(value)

	if t == "string" or t == "number" or t == "boolean" then
		return value
	elseif t == "nil" then
		return nil
	elseif t == "Vector3" then
		return { value.X, value.Y, value.Z }
	elseif t == "Vector2" then
		return { value.X, value.Y }
	elseif t == "CFrame" then
		local components = { value:GetComponents() }
		return {
			pos = { components[1], components[2], components[3] },
			rot = {
				components[4], components[5], components[6],
				components[7], components[8], components[9],
				components[10], components[11], components[12],
			},
		}
	elseif t == "Color3" then
		return { value.R, value.G, value.B }
	elseif t == "BrickColor" then
		return value.Name
	elseif t == "UDim" then
		return { value.Scale, value.Offset }
	elseif t == "UDim2" then
		return {
			{ value.X.Scale, value.X.Offset },
			{ value.Y.Scale, value.Y.Offset },
		}
	elseif t == "EnumItem" then
		return tostring(value)
	elseif t == "NumberRange" then
		return { value.Min, value.Max }
	elseif t == "NumberSequence" then
		local keypoints = {}
		for _, kp in ipairs(value.Keypoints) do
			table.insert(keypoints, { kp.Time, kp.Value, kp.Envelope })
		end
		return keypoints
	elseif t == "ColorSequence" then
		local keypoints = {}
		for _, kp in ipairs(value.Keypoints) do
			table.insert(keypoints, { kp.Time, kp.Value.R, kp.Value.G, kp.Value.B })
		end
		return keypoints
	elseif t == "Rect" then
		return { value.Min.X, value.Min.Y, value.Max.X, value.Max.Y }
	elseif t == "Font" then
		return {
			family = value.Family,
			weight = value.Weight.Name,
			style = value.Style.Name,
		}
	elseif t == "Faces" then
		local faces = {}
		if value.Top then table.insert(faces, "Top") end
		if value.Bottom then table.insert(faces, "Bottom") end
		if value.Left then table.insert(faces, "Left") end
		if value.Right then table.insert(faces, "Right") end
		if value.Front then table.insert(faces, "Front") end
		if value.Back then table.insert(faces, "Back") end
		return faces
	elseif t == "Axes" then
		local axes = {}
		if value.X then table.insert(axes, "X") end
		if value.Y then table.insert(axes, "Y") end
		if value.Z then table.insert(axes, "Z") end
		return axes
	elseif t == "PhysicalProperties" then
		if value then
			return {
				density = value.Density,
				friction = value.Friction,
				elasticity = value.Elasticity,
				frictionWeight = value.FrictionWeight,
				elasticityWeight = value.ElasticityWeight,
			}
		end
		return nil
	elseif t == "Ray" then
		return {
			origin = { value.Origin.X, value.Origin.Y, value.Origin.Z },
			direction = { value.Direction.X, value.Direction.Y, value.Direction.Z },
		}
	elseif t == "Instance" then
		return { _ref = value:GetFullName() }
	else
		return nil
	end
end

function PropertyHandler.deserializeValue(value, typeName)
	if typeName == "string" or typeName == "int" or typeName == "int64"
		or typeName == "float" or typeName == "double"
		or typeName == "bool" or typeName == "boolean" then
		return value
	end

	if typeName == "Vector3" and type(value) == "table" then
		return Vector3.new(value[1], value[2], value[3])
	elseif typeName == "Vector2" and type(value) == "table" then
		return Vector2.new(value[1], value[2])
	elseif typeName == "CFrame" and type(value) == "table" then
		local p = value.pos
		local r = value.rot
		return CFrame.new(p[1], p[2], p[3], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9])
	elseif typeName == "Color3" and type(value) == "table" then
		return Color3.new(value[1], value[2], value[3])
	elseif typeName == "BrickColor" and type(value) == "string" then
		return BrickColor.new(value)
	elseif typeName == "UDim" and type(value) == "table" then
		return UDim.new(value[1], value[2])
	elseif typeName == "UDim2" and type(value) == "table" then
		return UDim2.new(value[1][1], value[1][2], value[2][1], value[2][2])
	elseif typeName == "NumberRange" and type(value) == "table" then
		return NumberRange.new(value[1], value[2])
	elseif typeName == "NumberSequence" and type(value) == "table" then
		local keypoints = {}
		for _, kp in ipairs(value) do
			table.insert(keypoints, NumberSequenceKeypoint.new(kp[1], kp[2], kp[3]))
		end
		return NumberSequence.new(keypoints)
	elseif typeName == "ColorSequence" and type(value) == "table" then
		local keypoints = {}
		for _, kp in ipairs(value) do
			table.insert(keypoints, ColorSequenceKeypoint.new(kp[1], Color3.new(kp[2], kp[3], kp[4])))
		end
		return ColorSequence.new(keypoints)
	elseif typeName == "Rect" and type(value) == "table" then
		return Rect.new(value[1], value[2], value[3], value[4])
	elseif typeName == "Font" and type(value) == "table" then
		return Font.new(value.family, Enum.FontWeight[value.weight], Enum.FontStyle[value.style])
	elseif typeName == "Faces" and type(value) == "table" then
		local faceMap = {}
		for _, f in ipairs(value) do faceMap[f] = true end
		return Faces.new(
			faceMap.Right and Enum.NormalId.Right or nil,
			faceMap.Top and Enum.NormalId.Top or nil,
			faceMap.Back and Enum.NormalId.Back or nil,
			faceMap.Left and Enum.NormalId.Left or nil,
			faceMap.Bottom and Enum.NormalId.Bottom or nil,
			faceMap.Front and Enum.NormalId.Front or nil
		)
	elseif typeName == "Axes" and type(value) == "table" then
		local axisMap = {}
		for _, a in ipairs(value) do axisMap[a] = true end
		return Axes.new(
			axisMap.X and Enum.Axis.X or nil,
			axisMap.Y and Enum.Axis.Y or nil,
			axisMap.Z and Enum.Axis.Z or nil
		)
	elseif typeName == "PhysicalProperties" and type(value) == "table" then
		return PhysicalProperties.new(
			value.density, value.friction, value.elasticity,
			value.frictionWeight, value.elasticityWeight
		)
	end

	-- For Enum types passed as strings like "Enum.Material.Plastic"
	if type(value) == "string" and string.find(value, "^Enum%.") then
		local parts = string.split(value, ".")
		if #parts == 3 then
			local enumType = (Enum :: any)[parts[2]]
			if enumType then
				local item = (enumType :: any)[parts[3]]
				if item then
					return item
				end
			end
		end
	end

	return value
end

function PropertyHandler.getSerializableProperties(instance)
	local Config = _require("Config")
	local properties = {}
	local success, apiProperties = pcall(function()
		local className = instance.ClassName
		local result = {}

		-- Use pcall to safely read each property
		-- We rely on a known property list embedded in the serializer
		return result
	end)

	return properties
end

return PropertyHandler

end

_modules["UI"] = function()
local UI = {}

local LOG_PREFIX = "[Roblox Sync]"

function UI.showNotification(text, isWarning)
	-- Plugins cannot use StarterGui:SetCore (must be a LocalScript). Use Studio output only.
	if isWarning then
		warn(LOG_PREFIX .. " " .. text)
	else
		print(LOG_PREFIX .. " " .. text)
	end
end

return UI

end

_modules["HttpClient"] = function()
local HttpService = game:GetService("HttpService")
local Config = _require("Config")

local HttpClient = {}

function HttpClient.getBaseUrl()
	return Config.HOST .. ":" .. tostring(Config.PORT) .. "/api"
end

function HttpClient.get(endpoint)
	local url = HttpClient.getBaseUrl() .. endpoint
	local success, response = pcall(function()
		return HttpService:GetAsync(url, true)
	end)
	if success then
		return true, HttpService:JSONDecode(response)
	end
	return false, response
end

function HttpClient.post(endpoint, data)
	local url = HttpClient.getBaseUrl() .. endpoint
	local body = HttpService:JSONEncode(data)
	local success, response = pcall(function()
		return HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
	end)
	if success then
		local decodeSuccess, decoded = pcall(function()
			return HttpService:JSONDecode(response)
		end)
		if decodeSuccess then
			return true, decoded
		end
		return true, response
	end
	return false, response
end

return HttpClient

end

_modules["Serializer"] = function()
local Config = _require("Config")
local PropertyHandler = _require("PropertyHandler")
local PropertyDatabase = _require("PropertyDatabase")

local Serializer = {}
--- When false, duplicate sibling names only get unique names in the serialized tree (full sync); instances in Studio are not renamed.
Serializer.renameLiveInstancesForDuplicateNames = true

local _propCache = {}

local function getPropertyList(className)
	if _propCache[className] then
		return _propCache[className]
	end

	local props = {}
	local seen = {}
	local current = className

	while current do
		local entry = PropertyDatabase.data[current]
		if not entry then
			break
		end
		for _, prop in ipairs(entry.props) do
			if not seen[prop] then
				seen[prop] = true
				table.insert(props, prop)
			end
		end
		current = entry.super
	end

	_propCache[className] = props
	return props
end

--- Dot path from game child through instance (e.g. Workspace.Part), matching VS Code folder paths.
function Serializer.getInstanceDotPath(instance)
	if not instance then
		return "?"
	end
	local segments = {}
	local current = instance
	while current and current ~= game do
		table.insert(segments, 1, current.Name)
		current = current.Parent
	end
	return table.concat(segments, ".")
end

--- Stem + numeric suffix for sibling dedup: `Part` / `Part1` / `Part2` (compact) or legacy `Part_2`.
--- Unnumbered name counts as index 1.
function Serializer.stemAndSuffixIndex(name)
	local stemU, numStr = string.match(name, "^(.+)_([0-9]+)$")
	if stemU and numStr then
		return stemU, tonumber(numStr) or 1
	end
	local i = #name
	while i >= 1 do
		local c = string.byte(name, i)
		if c < 48 or c > 57 then
			break
		end
		i = i - 1
	end
	if i < #name and i >= 1 then
		local stem = string.sub(name, 1, i)
		local run = string.sub(name, i + 1)
		if stem ~= "" and run ~= "" then
			return stem, tonumber(run) or 1
		end
	end
	return name, 1
end

--- Next sibling name not in `occupied` (e.g. Part + Part → Part2; Part2 + Part2 → Part3). Uses Part2 not Part_2.
function Serializer.nextUniqueSiblingName(baseName, occupied)
	local stem = Serializer.stemAndSuffixIndex(baseName)
	local maxN = 0
	for occName, _ in pairs(occupied) do
		local s, idx = Serializer.stemAndSuffixIndex(occName)
		if s == stem then
			maxN = math.max(maxN, idx)
		end
	end
	local n = maxN + 1
	while true do
		local candidate = stem .. tostring(n)
		if not occupied[candidate] then
			return candidate
		end
		n = n + 1
	end
end

function Serializer.serializeInstance(instance)
	if Config.NON_SERIALIZABLE_CLASSES[instance.ClassName] then
		return nil
	end

	local data = {
		id = tostring(instance:GetDebugId()),
		className = instance.ClassName,
		name = instance.Name,
		properties = {},
		children = {},
	}

	local propList = getPropertyList(instance.ClassName)
	for _, propName in ipairs(propList) do
		if Config.IGNORED_PROPERTIES[propName] then
			continue
		end
		if propName == "Source" then
			if instance.ClassName == "Script" or instance.ClassName == "LocalScript" or instance.ClassName == "ModuleScript" then
				data.properties["Source"] = instance.Source
			end
			continue
		end
		local success, value = pcall(function()
			return (instance :: any)[propName]
		end)
		if success and value ~= nil then
			local serialized = PropertyHandler.serializeValue(value)
			if serialized ~= nil then
				data.properties[propName] = serialized
			end
		end
	end

	local occupied: { [string]: boolean } = {}
	local renameLive = Serializer.renameLiveInstancesForDuplicateNames == true
	for _, child in ipairs(instance:GetChildren()) do
		local childData = Serializer.serializeInstance(child)
		if childData then
			local baseName = childData.name
			local finalName = baseName
			if occupied[baseName] then
				finalName = Serializer.nextUniqueSiblingName(baseName, occupied)
				childData.name = finalName
				if renameLive then
					pcall(function()
						child.Name = finalName
					end)
				end
			end
			occupied[finalName] = true
			table.insert(data.children, childData)
		end
	end

	return data
end

function Serializer.serializeChange(changeType, instance, property, oldValue)
	local change = {
		type = changeType,
		instancePath = Serializer.getInstanceDotPath(instance),
		timestamp = os.clock(),
	}

	if changeType == "create" then
		change.instanceData = Serializer.serializeInstance(instance)
	elseif changeType == "update" and property then
		change.property = property
		local success, value = pcall(function()
			return (instance :: any)[property]
		end)
		if success then
			change.value = PropertyHandler.serializeValue(value)
		end
	elseif changeType == "delete" then
		-- Only need the path
	end

	return change
end

return Serializer

end

_modules["Deserializer"] = function()
local Config = _require("Config")
local PropertyHandler = _require("PropertyHandler")
local PropertyDatabase = _require("PropertyDatabase")

local Deserializer = {}

local function normalizeInstancePath(pathStr)
	if not pathStr or pathStr == "" then
		return pathStr
	end
	local parts = string.split(pathStr, ".")
	if #parts > 0 then
		local first = parts[1]
		if string.lower(first) == "game" then
			table.remove(parts, 1)
		end
	end
	return table.concat(parts, ".")
end

local function resolveInstancePath(path)
	path = normalizeInstancePath(path)
	local parts = string.split(path, ".")
	if #parts == 0 then
		return nil
	end

	local current = game
	for _, part in ipairs(parts) do
		local child = current:FindFirstChild(part)
		if not child then
			return nil
		end
		current = child
	end
	return current
end

local function getParentFromPath(path)
	path = normalizeInstancePath(path)
	local parts = string.split(path, ".")
	if #parts <= 1 then
		return nil, nil
	end

	local parentParts = {}
	for i = 1, #parts - 1 do
		table.insert(parentParts, parts[i])
	end

	local parentPath = table.concat(parentParts, ".")
	local childName = parts[#parts]
	return resolveInstancePath(parentPath), childName
end

local SCRIPT_CLASSES = {
	Script = true,
	LocalScript = true,
	ModuleScript = true,
}

local function propertyExistsForClass(className, propName)
	if propName == "Name" then
		return true
	end
	local current = className
	while current do
		local entry = PropertyDatabase.data[current]
		if not entry then
			break
		end
		for _, p in ipairs(entry.props) do
			if p == propName then
				return true
			end
		end
		current = entry.super
	end
	return false
end

-- Every property in the payload must exist on target class (Source only allowed for scripts)
local function propertiesValidForTargetClass(properties, targetClassName)
	if not properties then
		return true
	end
	for propName, _ in pairs(properties) do
		if propName ~= "Name" then
			if propName == "Source" then
				if not SCRIPT_CLASSES[targetClassName] then
					return false
				end
			else
				if not propertyExistsForClass(targetClassName, propName) then
					return false
				end
			end
		end
	end
	return true
end

-- Convert a raw JSON value to the correct Roblox type by inspecting
-- the instance's current property type or the value format
local function convertValue(instance, propName, rawValue)
	if rawValue == nil then
		return nil
	end

	-- Strings that look like enum values: "Enum.Material.Plastic" or just "Plastic"
	if type(rawValue) == "string" then
		-- Full enum path: "Enum.Material.Plastic"
		if string.find(rawValue, "^Enum%.") then
			local parts = string.split(rawValue, ".")
			if #parts == 3 then
				local enumType = (Enum :: any)[parts[2]]
				if enumType then
					local item = (enumType :: any)[parts[3]]
					if item then
						return item
					end
				end
			end
		end

		-- Try to match against the current property's enum type
		local ok, currentVal = pcall(function()
			return (instance :: any)[propName]
		end)
		if ok and typeof(currentVal) == "EnumItem" then
			local enumTypeName = tostring(currentVal.EnumType)
			local enumType = (Enum :: any)[enumTypeName]
			if enumType then
				local item = (enumType :: any)[rawValue]
				if item then
					return item
				end
			end
		end

		-- BrickColor check
		if ok and typeof(currentVal) == "BrickColor" then
			return BrickColor.new(rawValue)
		end

		return rawValue
	end

	-- Tables need conversion based on the current property type
	if type(rawValue) == "table" then
		local ok, currentVal = pcall(function()
			return (instance :: any)[propName]
		end)

		if ok and currentVal ~= nil then
			local currentType = typeof(currentVal)

			if currentType == "Vector3" then
				return Vector3.new(rawValue[1] or 0, rawValue[2] or 0, rawValue[3] or 0)
			elseif currentType == "Vector2" then
				return Vector2.new(rawValue[1] or 0, rawValue[2] or 0)
			elseif currentType == "Color3" then
				return Color3.new(rawValue[1] or 0, rawValue[2] or 0, rawValue[3] or 0)
			elseif currentType == "CFrame" then
				if rawValue.pos and rawValue.rot then
					local p = rawValue.pos
					local r = rawValue.rot
					return CFrame.new(
						p[1], p[2], p[3],
						r[1], r[2], r[3],
						r[4], r[5], r[6],
						r[7], r[8], r[9]
					)
				end
			elseif currentType == "UDim" then
				return UDim.new(rawValue[1] or 0, rawValue[2] or 0)
			elseif currentType == "UDim2" then
				return UDim2.new(
					rawValue[1][1] or 0, rawValue[1][2] or 0,
					rawValue[2][1] or 0, rawValue[2][2] or 0
				)
			elseif currentType == "NumberRange" then
				return NumberRange.new(rawValue[1] or 0, rawValue[2] or 0)
			elseif currentType == "Rect" then
				return Rect.new(rawValue[1] or 0, rawValue[2] or 0, rawValue[3] or 0, rawValue[4] or 0)
			elseif currentType == "NumberSequence" then
				local keypoints = {}
				for _, kp in ipairs(rawValue) do
					table.insert(keypoints, NumberSequenceKeypoint.new(kp[1], kp[2], kp[3] or 0))
				end
				return NumberSequence.new(keypoints)
			elseif currentType == "ColorSequence" then
				local keypoints = {}
				for _, kp in ipairs(rawValue) do
					table.insert(keypoints, ColorSequenceKeypoint.new(kp[1], Color3.new(kp[2], kp[3], kp[4])))
				end
				return ColorSequence.new(keypoints)
			elseif currentType == "Font" then
				if rawValue.family then
					return Font.new(
						rawValue.family,
						Enum.FontWeight[rawValue.weight or "Regular"],
						Enum.FontStyle[rawValue.style or "Normal"]
					)
				end
			elseif currentType == "Faces" then
				local faceMap = {}
				for _, f in ipairs(rawValue) do faceMap[f] = true end
				return Faces.new(
					faceMap.Right and Enum.NormalId.Right or nil,
					faceMap.Top and Enum.NormalId.Top or nil,
					faceMap.Back and Enum.NormalId.Back or nil,
					faceMap.Left and Enum.NormalId.Left or nil,
					faceMap.Bottom and Enum.NormalId.Bottom or nil,
					faceMap.Front and Enum.NormalId.Front or nil
				)
			elseif currentType == "Axes" then
				local axisMap = {}
				for _, a in ipairs(rawValue) do axisMap[a] = true end
				return Axes.new(
					axisMap.X and Enum.Axis.X or nil,
					axisMap.Y and Enum.Axis.Y or nil,
					axisMap.Z and Enum.Axis.Z or nil
				)
			elseif currentType == "PhysicalProperties" then
				return PhysicalProperties.new(
					rawValue.density, rawValue.friction, rawValue.elasticity,
					rawValue.frictionWeight, rawValue.elasticityWeight
				)
			end
		end

		-- Fallback: if it looks like a Vector3 array
		if #rawValue == 3 and type(rawValue[1]) == "number" then
			return Vector3.new(rawValue[1], rawValue[2], rawValue[3])
		end
		if #rawValue == 2 and type(rawValue[1]) == "number" then
			return Vector2.new(rawValue[1], rawValue[2])
		end
	end

	return rawValue
end

local function setProperty(instance, propName, rawValue)
	if propName == "Source" and SCRIPT_CLASSES[instance.ClassName] then
		pcall(function()
			instance.Source = rawValue
		end)
		return
	end

	local converted = convertValue(instance, propName, rawValue)
	local success, err = pcall(function()
		(instance :: any)[propName] = converted
	end)
	if not success then
		warn("[Roblox Sync] error: set " .. propName .. " on " .. instance:GetFullName() .. ": " .. tostring(err))
	end
end

function Deserializer.applyChange(change)
	if change.type == "create" then
		Deserializer.createInstance(change)
	elseif change.type == "update" then
		Deserializer.updateInstance(change)
	elseif change.type == "delete" then
		Deserializer.deleteInstance(change)
	elseif change.type == "rename" then
		Deserializer.renameInstance(change)
	end
end

function Deserializer.createInstance(change)
	if not change.instanceData then
		warn("[Roblox Sync] error: create change missing instanceData")
		return
	end

	-- If the instance already exists at this path, update it instead of creating a duplicate
	local existing = resolveInstancePath(change.instancePath)
	if existing then
		if change.instanceData.properties then
			for propName, propValue in pairs(change.instanceData.properties) do
				setProperty(existing, propName, propValue)
			end
		end
		return
	end

	local parent, _ = getParentFromPath(change.instancePath)
	if not parent then
		warn("[Roblox Sync] error: no parent for " .. change.instancePath)
		return
	end

	Deserializer.buildInstanceTree(change.instanceData, parent)
end

function Deserializer.buildInstanceTree(data, parent)
	local success, instance = pcall(function()
		return Instance.new(data.className)
	end)

	if not success then
		warn("[Roblox Sync] error: cannot create class " .. data.className)
		return nil
	end

	instance.Name = data.name

	for propName, propValue in pairs(data.properties or {}) do
		setProperty(instance, propName, propValue)
	end

	for _, childData in ipairs(data.children or {}) do
		Deserializer.buildInstanceTree(childData, instance)
	end

	instance.Parent = parent
	return instance
end

function Deserializer.updateInstance(change)
	local instance = resolveInstancePath(change.instancePath)
	if not instance then
		-- VS Code often sends "update" when saving init.meta.json even if Studio has no instance yet
		-- (e.g. cursor mode: folder first, meta added later). Treat as create.
		if change.instanceData then
			Deserializer.createInstance(change)
		end
		return
	end

	if change.instanceData and change.instanceData.className and change.instanceData.className ~= instance.ClassName then
		local newClass = change.instanceData.className
		if Config.CURSOR_MODE then
			if not propertiesValidForTargetClass(change.instanceData.properties, newClass) then
				warn(
					"[Roblox Sync] error: Cursor mode — class change to "
						.. newClass
						.. " deferred; remove properties from init.meta.json that are not valid for that class."
				)
				if change.instanceData.properties then
					for propName, propValue in pairs(change.instanceData.properties) do
						local ok = propertyExistsForClass(instance.ClassName, propName)
							or (propName == "Source" and SCRIPT_CLASSES[instance.ClassName])
						if ok then
							setProperty(instance, propName, propValue)
						end
					end
				end
				return
			end
		end

		-- className changed: convert object (destroy old, create new with same name)
		local parent = instance.Parent
		local preservedName = instance.Name
		instance:Destroy()

		local success, newInstance = pcall(function()
			return Instance.new(newClass)
		end)
		if not success then
			warn("[Roblox Sync] error: cannot convert to class " .. newClass)
			return
		end

		newInstance.Name = preservedName
		newInstance.Parent = parent
		if change.instanceData.properties then
			for propName, propValue in pairs(change.instanceData.properties) do
				setProperty(newInstance, propName, propValue)
			end
		end
		return
	end

	if change.instanceData then
		if change.instanceData.properties then
			for propName, propValue in pairs(change.instanceData.properties) do
				setProperty(instance, propName, propValue)
			end
		end
	elseif change.property and change.value ~= nil then
		setProperty(instance, change.property, change.value)
	end
end

function Deserializer.deleteInstance(change)
	local instance = resolveInstancePath(change.instancePath)
	if instance then
		instance:Destroy()
	end
end

function Deserializer.renameInstance(change)
	local instance = resolveInstancePath(change.instancePath)
	if instance and change.newName then
		instance.Name = change.newName
	end
end

--- Resolve a dot path (e.g. Workspace.Part) to an Instance, for post-apply serialization.
function Deserializer.resolveInstancePath(pathStr)
	return resolveInstancePath(pathStr)
end

return Deserializer

end

_modules["DuplicateSiblingWatcher"] = function()
local Config = _require("Config")
local Serializer = _require("Serializer")

local DuplicateSiblingWatcher = {}
DuplicateSiblingWatcher.__index = DuplicateSiblingWatcher

local function ensureUniqueAmongSiblings(instance)
	if not instance or not instance.Parent then
		return
	end
	local baseName = instance.Name
	local hasDupe = false
	for _, sibling in ipairs(instance.Parent:GetChildren()) do
		if sibling ~= instance and sibling.Name == baseName then
			hasDupe = true
			break
		end
	end
	if not hasDupe then
		return
	end
	local occupied = {}
	for _, sibling in ipairs(instance.Parent:GetChildren()) do
		if sibling ~= instance then
			occupied[sibling.Name] = true
		end
	end
	local candidate = Serializer.nextUniqueSiblingName(instance.Name, occupied)
	pcall(function()
		instance.Name = candidate
	end)
end

--- Used by ChangeDetector while syncing so the same rule applies whether or not VS Code is connected.
DuplicateSiblingWatcher.ensureUniqueAmongSiblings = ensureUniqueAmongSiblings

function DuplicateSiblingWatcher.new()
	local self = setmetatable({}, DuplicateSiblingWatcher)
	self._connections = {}
	self._nameConnections = {}
	self._tracking = false
	return self
end

function DuplicateSiblingWatcher:_trackNameCollision(instance)
	if Config.NON_SERIALIZABLE_CLASSES[instance.ClassName] then
		return
	end
	if self._nameConnections[instance] ~= nil then
		return
	end
	local conn = instance.Changed:Connect(function(property)
		if not self._tracking or property ~= "Name" then
			return
		end
		ensureUniqueAmongSiblings(instance)
	end)
	self._nameConnections[instance] = conn
end

function DuplicateSiblingWatcher:_untrackNameCollision(instance)
	local conn = self._nameConnections[instance]
	if conn then
		conn:Disconnect()
		self._nameConnections[instance] = nil
	end
end

--- Runs for the lifetime of the plugin (not tied to VS Code connection).
function DuplicateSiblingWatcher:start()
	if self._tracking then
		return
	end
	self._tracking = true

	for _, serviceName in ipairs(Config.SYNCED_SERVICES) do
		local service = game:FindService(serviceName)
		if not service then
			continue
		end

		for _, descendant in ipairs(service:GetDescendants()) do
			self:_trackNameCollision(descendant)
		end

		local addedConn = service.DescendantAdded:Connect(function(descendant)
			if not self._tracking then
				return
			end
			ensureUniqueAmongSiblings(descendant)
			self:_trackNameCollision(descendant)
		end)
		table.insert(self._connections, addedConn)

		local removingConn = service.DescendantRemoving:Connect(function(descendant)
			self:_untrackNameCollision(descendant)
		end)
		table.insert(self._connections, removingConn)
	end
end

function DuplicateSiblingWatcher:stop()
	self._tracking = false
	for _, conn in ipairs(self._connections) do
		conn:Disconnect()
	end
	self._connections = {}
	for _, conn in pairs(self._nameConnections) do
		conn:Disconnect()
	end
	self._nameConnections = {}
end

return DuplicateSiblingWatcher

end

_modules["ChangeDetector"] = function()
local Config = _require("Config")
local Serializer = _require("Serializer")
local DuplicateSiblingWatcher = _require("DuplicateSiblingWatcher")

-- New scripts from Studio get empty Source so sync matches VS Code (no default template race).
local SCRIPT_CLASS_NAMES = {
	Script = true,
	LocalScript = true,
	ModuleScript = true,
}

local ChangeDetector = {}
ChangeDetector.__index = ChangeDetector

function ChangeDetector.new()
	local self = setmetatable({}, ChangeDetector)
	self._connections = {}
	self._tracking = false
	self._pathCache = {}
	self._structureChanges = {}
	self._pendingUpdates = {}
	-- When true, property changes are ignored (used while applying VS Code changes)
	self._suppressed = false
	-- Ignore Source Changed while clearing new scripts' Source (defers create); avoids orphan updates before create flushes
	self._ignoreSourceUpdatesFor = {}
	return self
end

function ChangeDetector:suppress()
	self._suppressed = true
end

function ChangeDetector:unsuppress()
	self._suppressed = false
end

function ChangeDetector:startTracking()
	if self._tracking then
		return
	end
	self._tracking = true

	for _, serviceName in ipairs(Config.SYNCED_SERVICES) do
		local service = game:FindService(serviceName)
		if not service then
			continue
		end

		for _, descendant in ipairs(service:GetDescendants()) do
			self:_trackInstance(descendant)
		end

		local addedConn = service.DescendantAdded:Connect(function(descendant)
			if not self._tracking or self._suppressed then
				return
			end

			DuplicateSiblingWatcher.ensureUniqueAmongSiblings(descendant)

			self:_trackInstance(descendant)

			if SCRIPT_CLASS_NAMES[descendant.ClassName] then
				task.defer(function()
					if not self._tracking or self._suppressed then
						return
					end
					if descendant.Parent == nil then
						return
					end
					-- Suppress Source Changed so we don't enqueue a property-only update before the deferred create flushes
					local sid = tostring(descendant:GetDebugId())
					self._ignoreSourceUpdatesFor[sid] = true
					pcall(function()
						descendant.Source = ""
					end)
					self._ignoreSourceUpdatesFor[sid] = nil
					if not self._tracking or self._suppressed or descendant.Parent == nil then
						return
					end
					local change = Serializer.serializeChange("create", descendant)
					table.insert(self._structureChanges, change)
				end)
			else
				local change = Serializer.serializeChange("create", descendant)
				table.insert(self._structureChanges, change)
			end
		end)
		table.insert(self._connections, addedConn)

		local removingConn = service.DescendantRemoving:Connect(function(descendant)
			if not self._tracking or self._suppressed then
				return
			end

			local cachedPath = self._pathCache[descendant]
			if not cachedPath then
				cachedPath = Serializer.getInstanceDotPath(descendant)
			end
			-- Removing may run with Parent already cleared; single-segment paths are unreliable.
			if type(cachedPath) == "string" and not string.find(cachedPath, ".", 1, true) then
				local ok, full = pcall(function()
					return descendant:GetFullName()
				end)
				if ok and type(full) == "string" and string.find(full, ".", 1, true) then
					cachedPath = full
				end
			end

			self:_untrackInstance(descendant)

			local change = {
				type = "delete",
				instancePath = cachedPath,
				timestamp = os.clock(),
			}
			table.insert(self._structureChanges, change)
		end)
		table.insert(self._connections, removingConn)
	end
end

function ChangeDetector:stopTracking()
	self._tracking = false
	for _, conn in ipairs(self._connections) do
		conn:Disconnect()
	end
	self._connections = {}
	self._pathCache = {}
	self._pendingUpdates = {}
	self._structureChanges = {}
	self._ignoreSourceUpdatesFor = {}
end

--- Instances parented while _suppressed never got DescendantAdded handling; register them so deletes use full paths.
function ChangeDetector:catchUpUntrackedDescendants()
	if not self._tracking then
		return
	end
	for _, serviceName in ipairs(Config.SYNCED_SERVICES) do
		local service = game:FindService(serviceName)
		if not service then
			continue
		end
		for _, descendant in ipairs(service:GetDescendants()) do
			if self._pathCache[descendant] == nil then
				self:_trackInstance(descendant)
			end
		end
	end
end

function ChangeDetector:flushChanges()
	local changes = self._structureChanges
	self._structureChanges = {}

	for _, change in pairs(self._pendingUpdates) do
		table.insert(changes, change)
	end
	self._pendingUpdates = {}

	return changes
end

function ChangeDetector:_trackInstance(instance)
	if Config.NON_SERIALIZABLE_CLASSES[instance.ClassName] then
		return
	end

	if self._pathCache[instance] ~= nil then
		return
	end

	self._pathCache[instance] = Serializer.getInstanceDotPath(instance)

	local instanceId = tostring(instance:GetDebugId())

	local conn = instance.Changed:Connect(function(property)
		if not self._tracking or self._suppressed then
			return
		end

		if property == "Source" and self._ignoreSourceUpdatesFor[instanceId] then
			return
		end

		-- Handle renames before IGNORED_PROPERTIES check
		if property == "Name" then
			DuplicateSiblingWatcher.ensureUniqueAmongSiblings(instance)

			local oldPath = self._pathCache[instance]
			local finalName = instance.Name
			if instance.Parent then
				self._pathCache[instance] = Serializer.getInstanceDotPath(instance)
			end
			if oldPath then
				local change = {
					type = "rename",
					instancePath = oldPath,
					newName = finalName,
					oldName = string.match(oldPath, "[^%.]+$"),
					timestamp = os.clock(),
				}
				table.insert(self._structureChanges, change)
			end
			return
		end

		-- Handle reparenting before IGNORED_PROPERTIES check
		if property == "Parent" then
			local oldPath = self._pathCache[instance]
			if instance.Parent then
				self._pathCache[instance] = Serializer.getInstanceDotPath(instance)
				if oldPath then
					local deleteChange = {
						type = "delete",
						instancePath = oldPath,
						timestamp = os.clock(),
					}
					table.insert(self._structureChanges, deleteChange)
					local createChange = Serializer.serializeChange("create", instance)
					table.insert(self._structureChanges, createChange)
				end
			end
			return
		end

		if Config.IGNORED_PROPERTIES[property] then
			return
		end

		local debounceKey = instanceId .. "." .. property
		local change = Serializer.serializeChange("update", instance, property)
		self._pendingUpdates[debounceKey] = change
	end)

	table.insert(self._connections, conn)
end

function ChangeDetector:_untrackInstance(instance)
	self._pathCache[instance] = nil
end

return ChangeDetector

end

-- Entry point
do
local Config = _require("Config")

local Serializer = _require("Serializer")
local Deserializer = _require("Deserializer")
local ChangeDetector = _require("ChangeDetector")
local DuplicateSiblingWatcher = _require("DuplicateSiblingWatcher")
local UI = _require("UI")

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- DescendantAdded (and script follow-up) can run deferred; keep suppression through a few frames
-- so echoed creates are not flushed on the next poll as Studio ---> VS Code.
local HEARTBEATS_BEFORE_UNSUPPRESS = 3

local connected = false
local polling = false
local pingAlive = false
local sessionId = nil
local changeDetector = nil
local watcherAlive = true
local duplicateSiblingWatcher = DuplicateSiblingWatcher.new()
duplicateSiblingWatcher:start()
-- After a successful full sync; used to hide disconnect/poll noise during the brief VS Code reload window.
local lastFullySyncedAt = 0
local HANDOFF_GRACE_SEC = 8
-- Suppress duplicate "Connecting" / "Connected" Studio output when VS Code reloads and we reconnect (~10–30s later).
local lastStudioConnectBannerAt = 0
local STUDIO_CONNECT_BANNER_COOLDOWN_SEC = 90
-- Paths for which we echoed an Update after a VS Code create; filter duplicate ChangeDetector creates (incl. deferred scripts).
local suppressedVscodeCreatePaths = {}
-- Label for Studio output: matches API experience name when available (game.Name is often "Place 1").

local function withinHandoffGrace(): boolean
	return (os.clock() - lastFullySyncedAt) < HANDOFF_GRACE_SEC
end

local function getBaseUrl()
	return Config.HOST .. ":" .. tostring(Config.PORT) .. "/api"
end

local LOG_PREFIX = "[Roblox Sync]"

local function logLine(msg)
	print(LOG_PREFIX .. " " .. msg)
end

local function actionLabel(t)
	local m = {
		create = "Create",
		delete = "Delete",
		update = "Update",
		rename = "Rename",
	}
	if type(t) == "string" and m[t] then
		return m[t]
	end
	if type(t) == "string" and #t > 0 then
		return t:sub(1, 1):upper() .. t:sub(2)
	end
	return "?"
end

local function formatChangeSummary(change)
	local p = change.instancePath or "?"
	local act = actionLabel(change.type)
	if change.type == "rename" and change.oldName and change.newName then
		return string.format("%s %s (%s -> %s)", act, p, change.oldName, change.newName)
	end
	-- Updates: instance path only; ".Property" looks like hierarchy (e.g. LocalScript.Source).
	return string.format("%s %s", act, p)
end

local function filterFlushCreates(studioChanges, suppressed)
	if not studioChanges or #studioChanges == 0 then
		return studioChanges
	end
	if not suppressed or next(suppressed) == nil then
		return studioChanges
	end
	local out = {}
	for _, c in ipairs(studioChanges) do
		if not (c.type == "create" and suppressed[c.instancePath]) then
			table.insert(out, c)
		end
	end
	return out
end

--- Strip leading "game." for path matching (VS Code paths omit it).
local function normalizeInstancePathKey(p)
	if type(p) ~= "string" or p == "" then
		return nil
	end
	if string.sub(p, 1, 5) == "game." then
		return string.sub(p, 6)
	end
	return p
end

--- Same poll batch can include create (full snapshot) plus Changed updates for defaults (Source, Enabled, …). Drop redundant property-only updates.
local function dedupeUpdatesShadowedByCreatesInBatch(studioChanges)
	if not studioChanges or #studioChanges == 0 then
		return studioChanges
	end
	local created = {}
	for _, c in ipairs(studioChanges) do
		if c.type == "create" and type(c.instancePath) == "string" then
			created[c.instancePath] = true
			local n = normalizeInstancePathKey(c.instancePath)
			if n then
				created[n] = true
			end
		end
	end
	if next(created) == nil then
		return studioChanges
	end
	local out = {}
	for _, c in ipairs(studioChanges) do
		local drop = false
		if c.type == "update" and type(c.instancePath) == "string" and not c.instanceData then
			local p = c.instancePath
			local n = normalizeInstancePathKey(p)
			if created[p] or (n and created[n]) then
				drop = true
			end
		end
		if not drop then
			table.insert(out, c)
		end
	end
	return out
end

-- Roblox HttpService POST body limit is ~1024 KB; large places must full-sync in chunks.
local FULL_SYNC_MAX_BYTES = 950000
-- VS Code may start listening slightly after Studio posts; ConnectFail is common on first try.
local FULL_SYNC_HTTP_ATTEMPTS = 12

local function fullSyncPayloadByteLength(payload)
	local ok, encoded = pcall(function()
		return HttpService:JSONEncode(payload)
	end)
	if not ok or type(encoded) ~= "string" then
		return math.huge
	end
	return #encoded
end

local function postFullSyncRaw(encodedBody)
	local lastErr
	for attempt = 1, FULL_SYNC_HTTP_ATTEMPTS do
		local success, err = pcall(function()
			HttpService:PostAsync(
				getBaseUrl() .. "/full-sync",
				encodedBody,
				Enum.HttpContentType.ApplicationJson
			)
		end)
		if success then
			return true
		end
		lastErr = err
		if attempt < FULL_SYNC_HTTP_ATTEMPTS then
			task.wait(math.min(0.2 * attempt, 1.25))
		end
	end
	return false, lastErr
end

local function postFullSyncPayload(payload)
	local encoded = HttpService:JSONEncode(payload)
	return postFullSyncRaw(encoded)
end

local function skeletonInstance(node)
	return {
		id = node.id,
		className = node.className,
		name = node.name,
		properties = node.properties,
		children = {},
	}
end

local function splitAndPostChildren(parentPath, children)
	local i = 1
	local n = #children
	while i <= n do
		local batch = {}
		while i <= n do
			local cand = children[i]
			local onePayload = {
				mode = "children",
				parentPath = parentPath,
				instances = { cand },
			}
			if fullSyncPayloadByteLength(onePayload) > FULL_SYNC_MAX_BYTES then
				if #batch > 0 then
					break
				end
				local sk = skeletonInstance(cand)
				local okSk, errSk = postFullSyncPayload({
					mode = "children",
					parentPath = parentPath,
					instances = { sk },
				})
				if not okSk then
					return false, errSk
				end
				if cand.children and #cand.children > 0 then
					local childPath = parentPath .. "." .. sk.name
					local okDeep, errDeep = splitAndPostChildren(childPath, cand.children)
					if not okDeep then
						return false, errDeep
					end
				end
				i = i + 1
				break
			end
			local trial = {}
			for j = 1, #batch do
				trial[j] = batch[j]
			end
			trial[#trial + 1] = cand
			local trialPayload = {
				mode = "children",
				parentPath = parentPath,
				instances = trial,
			}
			if fullSyncPayloadByteLength(trialPayload) > FULL_SYNC_MAX_BYTES then
				break
			end
			batch = trial
			i = i + 1
		end
		if #batch > 0 then
			local okB, errB = postFullSyncPayload({
				mode = "children",
				parentPath = parentPath,
				instances = batch,
			})
			if not okB then
				return false, errB
			end
		end
	end
	return true
end

local function postServiceOrSplit(serviceNode)
	local rootsPayload = {
		mode = "roots",
		roots = { serviceNode },
	}
	if fullSyncPayloadByteLength(rootsPayload) <= FULL_SYNC_MAX_BYTES then
		return postFullSyncPayload(rootsPayload)
	end
	local sk = skeletonInstance(serviceNode)
	local skPayload = {
		mode = "roots",
		roots = { sk },
	}
	if fullSyncPayloadByteLength(skPayload) > FULL_SYNC_MAX_BYTES then
		return false, "single service root exceeds full-sync chunk limit"
	end
	local okSk, errSk = postFullSyncPayload(skPayload)
	if not okSk then
		return false, errSk
	end
	if serviceNode.children and #serviceNode.children > 0 then
		return splitAndPostChildren(serviceNode.name, serviceNode.children)
	end
	return true
end

local function postFullSyncEndSafe()
	pcall(function()
		HttpService:PostAsync(
			getBaseUrl() .. "/full-sync",
			HttpService:JSONEncode({ mode = "end" }),
			Enum.HttpContentType.ApplicationJson
		)
	end)
end

local function doFullSync()
	Serializer.renameLiveInstancesForDuplicateNames = false

	local tree = {}
	for _, serviceName in ipairs(Config.SYNCED_SERVICES) do
		local service = game:FindService(serviceName)
		if service then
			table.insert(tree, Serializer.serializeInstance(service))
		end
	end

	Serializer.renameLiveInstancesForDuplicateNames = true

	local legacyBody = { tree = tree }
	if fullSyncPayloadByteLength(legacyBody) <= FULL_SYNC_MAX_BYTES then
		local encodedLegacy = HttpService:JSONEncode(legacyBody)
		local success, err = postFullSyncRaw(encodedLegacy)
		if not success then
			warn(LOG_PREFIX .. " error: full sync failed: " .. tostring(err))
			return false
		end
		return true
	end

	local okBegin, errBegin = postFullSyncPayload({ mode = "begin" })
	if not okBegin then
		warn(LOG_PREFIX .. " error: full sync failed: " .. tostring(errBegin))
		postFullSyncEndSafe()
		return false
	end

	for _, svc in ipairs(tree) do
		local ok, err = postServiceOrSplit(svc)
		if not ok then
			warn(LOG_PREFIX .. " error: full sync failed: " .. tostring(err))
			postFullSyncEndSafe()
			return false
		end
	end

	local okEnd, errEnd = postFullSyncPayload({ mode = "end" })
	if not okEnd then
		warn(LOG_PREFIX .. " error: full sync failed: " .. tostring(errEnd))
		postFullSyncEndSafe()
		return false
	end

	return true
end

--- @param silentLog boolean if true, omit output (used for VS Code create echo — user already saw VS Code ---> Studio).
local function sendStudioChanges(changes, silentLog)
	if #changes == 0 then
		return
	end

	local url = getBaseUrl() .. "/studio-changes"
	if not silentLog then
		for _, change in ipairs(changes) do
			logLine("Studio ---> VS Code: " .. formatChangeSummary(change))
		end
	end

	local payload = { changes = changes }
	if silentLog then
		payload.silentLog = true
	end
	local body = HttpService:JSONEncode(payload)
	local success, err = pcall(function()
		HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
	end)
	if not success then
		warn(LOG_PREFIX .. " error: failed to send changes: " .. tostring(err))
	end
end

local function pollForChanges()
	local pollUrl = getBaseUrl() .. "/vscode-changes"
	local success, response = pcall(function()
		return HttpService:GetAsync(pollUrl, true)
	end)

	if not success then
		-- Normal when the VS Code server stops; avoid spam during disconnect (ConnectFail, etc.).
		return nil
	end

	local data = HttpService:JSONDecode(response)
	if data and data.cursorMode ~= nil then
		Config.CURSOR_MODE = data.cursorMode == true
	end
	if data and data.changes and #data.changes > 0 then
		if changeDetector then
			changeDetector:suppress()
		end
		for _, change in ipairs(data.changes) do
			-- Free this path for new Studio instances after VS Code delete/rename (see filterFlushCreates).
			if change.type == "delete" and type(change.instancePath) == "string" then
				suppressedVscodeCreatePaths[change.instancePath] = nil
			elseif change.type == "rename" and type(change.instancePath) == "string" then
				suppressedVscodeCreatePaths[change.instancePath] = nil
			end
			logLine("VS Code ---> Studio: " .. formatChangeSummary(change))
			Deserializer.applyChange(change)
		end
		-- Non–cursor mode: echo full instance snapshot from Studio (engine defaults) so VS Code can write init.meta.json + scripts.
		if not Config.CURSOR_MODE then
			local echoChanges = {}
			for _, change in ipairs(data.changes) do
				if change.type == "create" then
					local inst = Deserializer.resolveInstancePath(change.instancePath)
					if inst then
						local dotPath = Serializer.getInstanceDotPath(inst)
						suppressedVscodeCreatePaths[dotPath] = true
						suppressedVscodeCreatePaths[change.instancePath] = true
						local full = Serializer.serializeInstance(inst)
						if full then
							table.insert(echoChanges, {
								type = "update",
								instancePath = dotPath,
								instanceData = full,
								timestamp = os.clock(),
							})
						end
					end
				end
			end
			if #echoChanges > 0 then
				sendStudioChanges(echoChanges, true)
			end
		end
		if changeDetector then
			-- Instances created while suppressed never hit DescendantAdded; register paths for correct delete/rename paths.
			changeDetector:catchUpUntrackedDescendants()
			for _ = 1, HEARTBEATS_BEFORE_UNSUPPRESS do
				RunService.Heartbeat:Wait()
			end
			changeDetector:unsuppress()
		end
	end

	return data
end

local function startPolling()
	polling = true
	task.spawn(function()
		while polling and connected do
			pollForChanges()

			if changeDetector then
				local studioChanges = filterFlushCreates(changeDetector:flushChanges(), suppressedVscodeCreatePaths)
				studioChanges = dedupeUpdatesShadowedByCreatesInBatch(studioChanges)
				if #studioChanges > 0 then
					sendStudioChanges(studioChanges)
				end
			end

			task.wait(Config.POLL_INTERVAL)
		end
	end)
end

local function stopPolling()
	polling = false
end

local function stopPingLoop()
	pingAlive = false
end

--- @param silent boolean if true, omit user-visible errors for failed connect (background retries)
--- @param quietLog boolean if true, omit the disconnect print (workspace reload / session reset handoff)
local function disconnect(silent, quietLog)
	stopPingLoop()
	if not connected then
		stopPolling()
		if changeDetector then
			changeDetector:stopTracking()
			changeDetector = nil
		end
		return
	end

	stopPolling()

	if changeDetector then
		changeDetector:stopTracking()
		changeDetector = nil
	end

	pcall(function()
		HttpService:PostAsync(
			getBaseUrl() .. "/disconnect",
			HttpService:JSONEncode({ sessionId = sessionId }),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	connected = false
	sessionId = nil
	suppressedVscodeCreatePaths = {}
	if quietLog ~= true then
		logLine("Disconnected from VS Code")
	end
	if not silent then
		UI.showNotification("Disconnected from VS Code.")
	end
end

--- End Play Mode without tearing down the VS Code HTTP server (soft disconnect).
local function disconnectPlayMode()
	stopPingLoop()
	stopPolling()
	if changeDetector then
		changeDetector:stopTracking()
		changeDetector = nil
	end
	if connected and sessionId then
		pcall(function()
			HttpService:PostAsync(
				getBaseUrl() .. "/disconnect",
				HttpService:JSONEncode({ sessionId = sessionId, soft = true }),
				Enum.HttpContentType.ApplicationJson
			)
		end)
	end
	connected = false
	sessionId = nil
	suppressedVscodeCreatePaths = {}
	logLine("Sync paused (Play Mode). VS Code keeps running; will resume when you stop play.")
end

local function startPingLoop()
	stopPingLoop()
	pingAlive = true
	task.spawn(function()
		while pingAlive and connected and watcherAlive do
			local ok = pcall(function()
				HttpService:GetAsync(getBaseUrl() .. "/ping", true)
			end)
			if not ok then
				if connected and pingAlive then
					disconnect(true, withinHandoffGrace())
				end
				break
			end
			task.wait(Config.STUDIO_PING_INTERVAL)
		end
	end)
end

--- Experience title for logs / VS Code (not the document tab name: Place1, Place2, …).
local function tryNameFromUniverseId(universeId, placeFileName)
	if type(universeId) ~= "number" or universeId <= 0 then
		return nil
	end

	local MarketplaceService = game:GetService("MarketplaceService")
	local okMp, productInfo = pcall(function()
		return MarketplaceService:GetProductInfo(universeId, Enum.InfoType.Game)
	end)
	if okMp and type(productInfo) == "table" then
		local n = productInfo.Name or productInfo.name
		if type(n) == "string" and n ~= "" then
			return n
		end
	end

	for attempt = 1, 4 do
		local ok2, gameResp = pcall(function()
			return HttpService:GetAsync("https://games.roblox.com/v1/games?universeIds=" .. tostring(universeId))
		end)
		if ok2 and type(gameResp) == "string" and gameResp ~= "" then
			local decodeOk, gameData = pcall(function()
				return HttpService:JSONDecode(gameResp)
			end)
			if decodeOk and type(gameData) == "table" then
				local row = gameData.data and gameData.data[1]
				if type(row) == "table" and type(row.name) == "string" and row.name ~= "" then
					return row.name
				end
			end
		end
		if attempt < 4 then
			task.wait(0.2 * attempt)
		end
	end

	return nil
end

local function tryMultigetPlaceDetails(placeId)
	if type(placeId) ~= "number" or placeId <= 0 then
		return nil, nil
	end
	local url = "https://games.roblox.com/v1/games/multiget-place-details?placeIds=" .. tostring(placeId)
	for attempt = 1, 4 do
		local ok, resp = pcall(function()
			return HttpService:GetAsync(url)
		end)
		if ok and type(resp) == "string" and resp ~= "" then
			local decOk, data = pcall(function()
				return HttpService:JSONDecode(resp)
			end)
			if decOk and type(data) == "table" then
				local rows = data.places or data.placeDetails or data.data or data
				if type(rows) == "table" and type(rows[1]) == "table" then
					local row = rows[1]
					local uid = row.universeId or row.universeID
					local n = row.name or row.sourceName
					if type(uid) == "number" and uid > 0 and type(n) == "string" and n ~= "" then
						return n, uid
					end
					if type(n) == "string" and n ~= "" then
						return n, type(uid) == "number" and uid > 0 and uid or nil
					end
					if type(uid) == "number" and uid > 0 then
						return nil, uid
					end
				end
			end
		end
		if attempt < 4 then
			task.wait(0.2 * attempt)
		end
	end
	return nil, nil
end

local function resolveExperienceDisplayName(placeId, placeFileName)
	local universeId = nil
	local okGid, gid = pcall(function()
		return game.GameId
	end)
	if okGid and type(gid) == "number" and gid > 0 then
		universeId = gid
	end

	local fromMarket = universeId and tryNameFromUniverseId(universeId, placeFileName) or nil
	if fromMarket then
		return fromMarket
	end

	if type(placeId) == "number" and placeId > 0 then
		local multiName, multiUniverse = tryMultigetPlaceDetails(placeId)
		if type(multiName) == "string" and multiName ~= "" then
			return multiName
		end
		if not universeId and type(multiUniverse) == "number" and multiUniverse > 0 then
			universeId = multiUniverse
			local fromMultiU = tryNameFromUniverseId(universeId, placeFileName)
			if fromMultiU then
				return fromMultiU
			end
		end
	end

	if not universeId and type(placeId) == "number" and placeId > 0 then
		for attempt = 1, 4 do
			local ok, uniResp = pcall(function()
				return HttpService:GetAsync("https://apis.roblox.com/universes/v1/places/" .. tostring(placeId) .. "/universe")
			end)
			if ok and type(uniResp) == "string" and uniResp ~= "" then
				local decodeOk, uniData = pcall(function()
					return HttpService:JSONDecode(uniResp)
				end)
				if decodeOk and type(uniData) == "table" and type(uniData.universeId) == "number" and uniData.universeId > 0 then
					universeId = uniData.universeId
					break
				end
			end
			if attempt < 4 then
				task.wait(0.2 * attempt)
			end
		end
	end

	if universeId then
		local n = tryNameFromUniverseId(universeId, placeFileName)
		if n then
			return n
		end
	end

	return placeFileName
end

--- @param silent boolean if true, omit connection-failed toast (used while polling until server is up)
local function connect(silent)
	if connected then
		return
	end
	if RunService:IsRunning() then
		return
	end

	local placeId = game.PlaceId or 0
	local placeName = game.Name or "Unnamed"
	local gameId = 0
	do
		local okGi, gi = pcall(function()
			return game.GameId
		end)
		if okGi and type(gi) == "number" and gi > 0 then
			gameId = gi
		end
	end
	local structureHash = ""
	if placeId == 0 then
		local parts = {}
		for _, serviceName in ipairs(Config.SYNCED_SERVICES) do
			local service = game:FindService(serviceName)
			if service then
				table.insert(parts, serviceName .. ":" .. tostring(#service:GetChildren()))
			end
		end
		local str = table.concat(parts, "|")
		local h = 0
		for i = 1, #str do
			h = (h * 31 + string.byte(str, i)) % 2147483647
		end
		structureHash = tostring(math.abs(h))
	end

	-- Always resolve display title: PlaceId can be 0 while game.GameId still identifies the live experience.
	local experienceName = resolveExperienceDisplayName(placeId, placeName)

	local connectUrl = getBaseUrl() .. "/connect"
	local connectStartedAt = os.clock()
	local allowConnectBanner = lastStudioConnectBannerAt == 0
		or (connectStartedAt - lastStudioConnectBannerAt) >= STUDIO_CONNECT_BANNER_COOLDOWN_SEC
	local success, response = pcall(function()
		return HttpService:PostAsync(
			connectUrl,
			HttpService:JSONEncode({
				version = "1.5.0",
				placeId = placeId,
				placeName = placeName,
				experienceName = experienceName,
				structureHash = structureHash,
				gameId = gameId,
			}),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if not success then
		if not silent then
			warn(LOG_PREFIX .. " error: could not connect: " .. tostring(response))
			UI.showNotification("Connection failed. In VS Code run Roblox Sync: Connect to Studio.", true)
		end
		return
	end

	local data = HttpService:JSONDecode(response)
	sessionId = data.sessionId
	connected = true

	changeDetector = ChangeDetector.new()

	if doFullSync() then
		lastFullySyncedAt = os.clock()
		changeDetector:startTracking()
		startPolling()
		startPingLoop()
		if allowConnectBanner then
			logLine("Connected to VS Code")
			lastStudioConnectBannerAt = os.clock()
		end
	else
		connected = false
		sessionId = nil
		changeDetector = nil
		UI.showNotification("Full sync failed.", true)
	end
end

plugin.Unloading:Connect(function()
	watcherAlive = false
	duplicateSiblingWatcher:stop()
	disconnect(true)
end)

-- Poll for VS Code server; auto-connect when it appears; disconnect locally when server stops.
task.spawn(function()
	while watcherAlive do
		if RunService:IsRunning() then
			if connected then
				disconnectPlayMode()
			end
			task.wait(Config.POLL_INTERVAL)
			continue
		end

		local ok, response = pcall(function()
			return HttpService:GetAsync(getBaseUrl() .. "/status", true)
		end)

		if ok and type(response) == "string" and response ~= "" then
			local decOk, data = pcall(function()
				return HttpService:JSONDecode(response)
			end)
			if decOk and type(data) == "table" then
				if type(data.studioPingIntervalSec) == "number" and data.studioPingIntervalSec > 0 then
					Config.STUDIO_PING_INTERVAL = math.clamp(data.studioPingIntervalSec, 3, 30)
				end
				-- After a Cursor/VS Code window reload, the HTTP server comes back with connected=false
				-- while we still have connected=true; reconnect in the same poll cycle.
				-- Only skip the Disconnected log during handoff grace (same as ping / status loss).
				if data.connected == false and connected then
					disconnect(true, withinHandoffGrace())
				end
				if not connected then
					connect(true)
				end
			end
		else
			if connected then
				local g = withinHandoffGrace()
				disconnect(true, g)
			end
		end

		task.wait(Config.POLL_INTERVAL)
	end
end)

end
