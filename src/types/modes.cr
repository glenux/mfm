module GX::Types
  enum Mode
    None

    GlobalVersion
    GlobalHelp
    # GlobalCompletion
    GlobalTui
    GlobalConfig
    GlobalMapping

    CompletionBash
    CompletionZsh
    CompletionAutodetect

    ConfigInit

    MappingCreate
    MappingDelete
    MappingEdit
    MappingList
    MappingMount
    MappingUmount
  end
end
