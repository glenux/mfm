module GX::Types
  enum Mode
    None

    GlobalVersion
    GlobalHelp
    GlobalCompletion
    GlobalTui
    GlobalConfig
    GlobalMapping

    ConfigInit

    MappingCreate
    MappingDelete
    MappingEdit
    MappingList
    MappingMount
    MappingUmount
  end
end
