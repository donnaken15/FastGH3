AnimPreviewBaseTree = {
	Type = DegenerateBlend
	id = PreviewTreeAnimNode
}

script AnimTreePreview_UpdateBlendValues
	if CompositeObjectExists \{name = AnimTreePreviewObject}
		AnimTreePreviewObject ::AnimPreview_SetSourceValues <...>
	endif
endscript
TestAnimScript = $WhyAmIBeingCalled
AnimTreePreview_NxCommon = $WhyAmIBeingCalled
CreateFakePlayer = $WhyAmIBeingCalled
