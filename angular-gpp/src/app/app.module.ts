import { registerLocaleData } from '@angular/common';
import localePt from '@angular/common/locales/pt';

registerLocaleData(localePt);

import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { ChangeDetectionStrategy, Component } from '@angular/core';
import 'eva-icons';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { NbButtonModule, NbCardModule, NbCheckboxModule, NbInputModule, NbLayoutModule, NbMenuModule, NbSelectModule, NbSidebarModule, NbThemeModule } from '@nebular/theme';
import { Ng2SmartTableModule } from 'ng2-smart-table';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { EntregaComponent } from './components/entrega/entrega.component';
import { NbEvaIconsModule } from '@nebular/eva-icons';
import { ClienteListComponent } from './components/cliente-list/cliente-list.component';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { ClienteComponent } from './components/cliente/cliente.component';
import { FilialHeaderComponent } from './components/filial-header/filial-header.component';
import { ButtonModule } from 'primeng/button';
import { ButtonBasicDemoComponent } from './components/button-basic-demo/button-basic-demo.component';
import { TableModule } from 'primeng/table';
import { PecaTableComponent } from './components/peca-table/peca-table.component';
import { DockModule } from 'primeng/dock';
import { BasicDocComponent } from './components/basic-doc/basic-doc.component';
import { RadioButtonModule } from 'primeng/radiobutton';
import { PanelMenuBasicDemoComponent } from './components/menu/menu.component';
import { PanelMenuModule } from 'primeng/panelmenu';
import { PecaFormComponent } from './components/peca-form/peca-form.component';
import {DialogModule} from 'primeng/dialog';
import {InputTextModule} from 'primeng/inputtext';
import {CheckboxModule} from 'primeng/checkbox';
import {DropdownModule} from 'primeng/dropdown';
import { PecaEditComponent } from './components/peca-edit/peca-edit.component';
import { FornecedorFormComponent } from './components/fornecedor-form/fornecedor-form.component';
import { FornecedorTableComponent } from './components/fornecedor-table/fornecedor-table.component';
import { FornecedorFormEditComponent } from './components/fornecedor-form-edit/fornecedor-form-edit.component';
import { ProdutoTableComponent } from './components/produto-table/produto-table.component';
import { ProdutoFormComponent } from './components/produto-form/produto-form.component';
import { AutoCompleteModule } from 'primeng/autocomplete';
import { MessageModule } from 'primeng/message';
import { MessageService } from 'primeng/api';
import { CommonModule } from '@angular/common';
import { MessagesModule } from 'primeng/messages';
import { AstecaFormComponent } from './components/asteca-form/asteca-form.component';
import { AstecaTableComponent } from './components/asteca-table/asteca-table.component';
import { DialogService } from 'primeng/dynamicdialog';
import { ListboxModule } from 'primeng/listbox';
import { FieldsetModule } from 'primeng/fieldset';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { ProdutoEditComponent } from './components/produto-edit/produto-edit.component';
import { AstecaEditComponent } from './components/asteca-edit/asteca-edit.component';
import { PecaEstoqueTableComponent } from './components/pecaestoque-table/pecaestoque-table.component';
import { PecaEstoqueFormComponent } from './components/pecaestoque-form/pecaestoque-form.component';
import { ConfirmDialogModule } from 'primeng/confirmdialog';
import { ToastModule } from 'primeng/toast';
import { InputMaskModule } from 'primeng/inputmask';
import { InputNumberModule } from 'primeng/inputnumber';




registerLocaleData(localePt);
@NgModule({
  declarations: [
    AppComponent,
    EntregaComponent,
    ClienteListComponent,
    ClienteComponent,
    FilialHeaderComponent,
    ButtonBasicDemoComponent,
    PecaTableComponent,
    BasicDocComponent,
    PanelMenuBasicDemoComponent,
    PecaFormComponent,
    PecaEditComponent,
    FornecedorFormComponent,
    FornecedorTableComponent,
    FornecedorFormEditComponent,
    ProdutoTableComponent,
    ProdutoFormComponent,
    AstecaFormComponent,
    AstecaTableComponent,
    DashboardComponent,
    ProdutoEditComponent,
    PecaEstoqueTableComponent,
    PecaEstoqueFormComponent,
    AstecaEditComponent,
     
  ],
  imports: [
    InputTextModule,
    FieldsetModule,
    ListboxModule,
    MessagesModule,
    MessageModule,
    AutoCompleteModule,
    DialogModule,
    ButtonModule,
    InputTextModule,
    CheckboxModule,
    DropdownModule,
    PanelMenuModule,
    RadioButtonModule,
    DockModule,
    TableModule,
    ButtonModule,
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    NbThemeModule.forRoot(),
    NbLayoutModule,
    NbSidebarModule.forRoot(),
    NbButtonModule,
    NbInputModule,
    Ng2SmartTableModule,
    NbCheckboxModule,
    NbMenuModule.forRoot(),
    NbCardModule,
    BrowserAnimationsModule,
    NbEvaIconsModule,
    HttpClientModule,
    NbSelectModule,
    ReactiveFormsModule,
    ConfirmDialogModule,
    ToastModule,
    InputMaskModule,
    InputNumberModule
  ],
  providers: [MessageService, DialogService],
  bootstrap: [AppComponent]
})


export class AppModule { }
