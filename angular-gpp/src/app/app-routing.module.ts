import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { EntregaComponent } from './components/entrega/entrega.component';
import { LoginComponent } from './components/login/login.component';
import { ClienteListComponent } from './components/cliente-list/cliente-list.component';
import { ClienteComponent } from './components/cliente/cliente.component';
import { PecaTableComponent } from './components/peca-table/peca-table.component';
import { PecaFormComponent } from './components/peca-form/peca-form.component';
import { PecaEditComponent } from './components/peca-edit/peca-edit.component';
import { FornecedorFormComponent } from './components/fornecedor-form/fornecedor-form.component';
import { FornecedorTableComponent } from './components/fornecedor-table/fornecedor-table.component';
import { FornecedorFormEditComponent } from './components/fornecedor-form-edit/fornecedor-form-edit.component';
import { ProdutoTableComponent } from './components/produto-table/produto-table.component';
import { ProdutoFormComponent } from './components/produto-form/produto-form.component';
import { AstecaFormComponent } from './components/asteca-form/asteca-form.component';
import { AstecaTableComponent } from './components/asteca-table/asteca-table.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { ProdutoEditComponent } from './components/produto-edit/produto-edit.component';
import { AstecaEditComponent } from './components/asteca-edit/asteca-edit.component';
import { PecaEstoqueTableComponent } from './components/pecaestoque-table/pecaestoque-table.component';
import { PecaEstoqueFormComponent } from './components/pecaestoque-form/pecaestoque-form.component';

const routes: Routes = [
  {path: 'dashboard', component: DashboardComponent},
  {path: 'asteca/:id', component: AstecaFormComponent},
  {path: 'astecaList', component: AstecaTableComponent},
  {path: 'pecaestoque/:id', component: PecaEstoqueFormComponent},
  {path: 'pecaestoqueList', component: PecaEstoqueTableComponent},
  {path: 'produto/:id', component: ProdutoFormComponent},
  {path: 'produtoList', component: ProdutoTableComponent},
  {path: 'fornecedor/:id', component: FornecedorFormComponent},
  {path: 'fornecedorList', component: FornecedorTableComponent},
  {path: 'peca/editar/:id', component: PecaEditComponent },
  {path: 'fornecedor/editar/:id', component: FornecedorFormEditComponent },
  {path: '', component: LoginComponent},
  {path: 'login', component: LoginComponent},
  // {path: 'peca/:id', component: PecaComponent},
  {path: 'peca/:id', component: PecaFormComponent},
  // {path: 'pecaList', component: PecaListComponent},
  {path: 'pecaList', component: PecaTableComponent},
  {path: 'clienteList', component: ClienteListComponent},
  {path: 'cliente/:id', component: ClienteComponent},
  {path: 'teste', component: PecaTableComponent},
  {path: 'produto/editar/:id', component: ProdutoEditComponent},
  {path: 'asteca/editar/:id', component: AstecaEditComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
