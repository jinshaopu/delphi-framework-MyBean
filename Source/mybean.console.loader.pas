(*
 *	 Unit owner: D10.Mofen
 *	       blog: http://www.cnblogs.com/dksoft
 *
 *   v0.1.0(2014-08-29 13:00)
 *     修改加载方式(beanMananger.dll-改造)
 *
 *	 v0.0.1(2014-05-17)
 *     + first release
 *
 *
 *)
 
unit mybean.console.loader;

interface

uses
  mybean.core.intf, superobject, Windows, SysUtils;

type
  TBaseFactoryObject = class(TObject)
  private
    FTag: Integer;
  protected
    /// <summary>
    ///   bean的配置,文件中读取的有一个list配置数组
    /// </summary>
    FConfig: ISuperObject;
  protected
    FBeanFactory: IBeanFactory;
    FNamespace: string;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure Cleanup; virtual;

    procedure CheckFinalize; virtual;

    procedure CheckInitialize; virtual;

    /// <summary>
    ///   检测是否是有效的插件宿主文件
    /// </summary>
    function CheckIsValidLib(pvUnLoadIfSucc: Boolean = false): Boolean; virtual;

    /// <summary>
    ///   beanID和配置信息
    /// </summary>
    procedure AddBeanConfig(pvBeanConfig: ISuperObject);

    /// <summary>
    ///   根据beanID获取插件
    /// </summary>
    function GetBean(pvBeanID:string): IInterface; virtual;

    /// <summary>
    ///   DLL中BeanFactory接口
    /// </summary>
    property BeanFactory: IBeanFactory read FBeanFactory;

    property Namespace: string read FNamespace;

    property Tag: Integer read FTag write FTag;


  end;

  /// <summary>
  ///   可以用户手动注册实例
  /// </summary>
  TFactoryInstanceObject = class(TBaseFactoryObject)
  public
    procedure SetFactoryObject(const intf:IBeanFactory);
    procedure SetNameSpace(const pvNameSpace: string);
  end;

implementation

uses
  mybean.core.SOTools;

constructor TBaseFactoryObject.Create;
begin
  inherited Create;
  FTag := 0;
  FConfig := SO();
  FConfig.O['list'] := SO('[]');
end;

destructor TBaseFactoryObject.Destroy;
begin
  FConfig := nil;
  inherited Destroy;
end;

function TBaseFactoryObject.GetBean(pvBeanID:string): IInterface;
begin
  if BeanFactory = nil then
  begin
    CheckInitialize;
  end;

  if BeanFactory <> nil then
  begin
    Result := BeanFactory.GetBean(PAnsiChar(AnsiString(pvBeanID)));
  end;
end;

{ TBaseFactoryObject }

procedure TBaseFactoryObject.CheckFinalize;
begin
  if FBeanFactory <> nil then
  begin
    FBeanFactory.CheckFinalize;
  end;
end;

procedure TBaseFactoryObject.CheckInitialize;
begin

end;

procedure TBaseFactoryObject.Cleanup;
begin
  FBeanFactory := nil;
end;

procedure TBaseFactoryObject.AddBeanConfig(pvBeanConfig: ISuperObject);
begin
  FConfig.A['list'].Add(pvBeanConfig);
end;

function TBaseFactoryObject.CheckIsValidLib(pvUnLoadIfSucc: Boolean = false):
    Boolean;
begin
  Result := False;
end;

procedure TFactoryInstanceObject.SetFactoryObject(const intf:IBeanFactory);
begin
  FbeanFactory := intf;
end;

procedure TFactoryInstanceObject.SetNameSpace(const pvNameSpace: string);
begin
  Fnamespace := pvNameSpace;
end;

end.
